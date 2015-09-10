
Constant =
	contactType: [
		{"name": "手机"		, "value": 1},
		{"name": "家庭"		, "value": 2},
		{"name": "工作单位"	, "value": 3},
		{"name": "其他"		, "value": 4}
		]

	debtStatusType: [
		{value: 1, name: '电催'},
		{value: 2, name: '外访'},
		{value: 3, name: '信函'},
		{value: 4, name: '搜索'},
		
		{value: 10, name: '已排程'},
		{value: 11, name: '外访完成'},
		{value: 12, name: '承诺还款'},
		{value: 13, name: '失联案件'},
		{value: 14, name: '暂停催收'},
		{value: 15, name: '紧急案件'},
		{value: 16, name: '已查帐'},
		{value: 17, name: '转告'},
		{value: 18, name: '一次查找'},
		{value: 19, name: '搜索案件'},
		{value: 20, name: '争议案件'},
		{value: 21, name: '分期还款'},
		{value: 22, name: '夜间催收'},
		{value: 23, name: '最新线索'},
		{value: 24, name: '仿冒判刑死亡'},
		{value: 25, name: '户籍跟催'},
		
		{value: 99, name: '其他'}
		]

	debtState:
		TO_CHECK		: 0
		CHECKING		: 1
		CHECKED_PASS	: 2
		CHECKED_FAILED	: 3
		DEAL			: 4
		COMPLETED		: 5


angular.module('app').constant 'constant', Constant
