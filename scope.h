#ifndef __SCOPE_H__
#define __SCOPE_H__

#include <map>



class Scope {
	public:
		Scope();
		void initializeVar(char* id, int newValue);
		int getVar(char* id);
		void setVar(char* id, int newValue);
	private:
		std::map<char*, int> variables;
};




#endif
