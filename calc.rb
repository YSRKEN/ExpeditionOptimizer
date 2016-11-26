require 'csv'
Encoding.default_external = "UTF-8"
#関数定義
def limit(n, a, b)
	[[n, a].max, b].min
end
#引数読み込み
TABLE_TYPE   = limit(ARGV[0].to_i,1,2)
SUPPLY = [eval(ARGV[1]).to_i,eval(ARGV[2]).to_i,eval(ARGV[3]).to_i,eval(ARGV[4]).to_i]
FLEETS       = limit(ARGV[5].to_i,1,4)
PAULING_TIME = [ARGV[6].to_i,1].max
AUTO_SUPPLY  = limit(ARGV[7].to_i,0,1)
# テーブルを読み込む
table = []
CSV.table("table#{TABLE_TYPE}.csv").each{|record|
	table.push([
		record[:supply1].to_i,
		record[:supply2].to_i,
		record[:supply3].to_i,
		record[:supply4].to_i,
		record[:name].to_s,
		[record[:time].to_i,PAULING_TIME].max,
		record[:info].to_s
	])
}
table_size = table.size
# 制約式に変換する
query_file = ''
#目的関数
query_file << "minimize\nmin_time\nsubject to\n"
#制約条件(資源の総和)
num = [1, 1, 1, 1.0/3]
4.times{|si|
	table_size.times{|ni|
		query_file << "+#{table[ni][si]} x#{ni} "
	}
	if AUTO_SUPPLY == 1
		query_file << "+#{num[si]} min_time "
	end
	query_file << ">= #{SUPPLY[si]}\n"
}
#制約条件(時間の総和)
query_file << "all_time "
table_size.times{|ni|
	query_file << "-#{table[ni][5]} x#{ni} "
}
query_file << "= 0\n"
#制約条件(遠征に関する最大値最小化)
query_file << "min_time - all_time >= 0\n"
table_size.times{|ni|
	query_file << "min_time -#{table[ni][5] * FLEETS} x#{ni} >= 0\n"
}
#制約条件(整数制約)
query_file << "general\n"
table_size.times{|ni|
	query_file << "x#{ni} "
}
query_file << "\n"
#終端
query_file << "end\n"
#解かせる
File.write("temp.lp", query_file)
File.write('query.txt', "read temp.lp\noptimize\nwrite solution query.sol\nquit")
system("cmd.exe /c scip.exe < query.txt > result.txt")
#結果表示
sol_list = []
min_time = 0.0
File.read('query.sol').split("\n").each{|line|
	line_split = line.gsub(/ {2,}/, ' ').split(' ')
	if line_split[0][0] == 'x'
		index = line_split[0].sub('x', '').to_i
		count = line_split[1].to_i
		sol_list.push([index, count])
	end
	if line_split[0] == 'min_time'
		min_time = 1.0 * line_split[1].to_i / FLEETS
	end
}
sol_list.sort!{|a, b|
	b[1] * table[b[0]][5] <=> a[1] * table[a[0]][5]
}
puts "○遠征内容"
sol_list.each{|sol|
	puts "　#{table[sol[0]][4]}×#{sol[1]}回‖のべ#{sol[1] * table[sol[0]][5]}分‖#{table[sol[0]][6]}"
}
puts "○所要時間"
puts "　所要時間[分]：#{min_time}"
puts "　所要時間[時]：#{min_time / 60}"
puts "　所要時間[日]：#{min_time / 60 / 24}"
