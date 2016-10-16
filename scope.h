#ifndef __SCOPE_H__
#define __SCOPE_H__

#include <map>
#include <string>



class Scope {
	public:
		Scope();
		void initializeVar(char* id, int newValue);
		int getVar(char* id);
		void setVar(char* id, int newValue);
		bool isVar(char* id);
	private:
		std::map<std::string, int> variables;
};




#endif
