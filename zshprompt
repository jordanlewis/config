declare -A gitinfo

local -A c
c[br]=%F{cyan}      # branch name color
c[halt]=%F{magenta} # abnormal status color
c[sha]=%F{yellow}   # sha color
c[plus]=%F{green}   # revisions ahead color
c[minus]=%F{red}    # revisions behind color
c[equal]=%F{blue}
c[none]=%f%k%b


gitinfo_update() {
	gitinfo=()
	tmp=$(pwd | egrep '\/\.git')
	if [[ $? -eq 0 ]]; then
		# We're inside a .git folder which is going to cause 
		# problems for rev-parse
		return
	fi
	gitinfo[dir]=$(git rev-parse --git-dir 2>/dev/null)
	if [[ $? -ne 0 ]] || [[ -z "$gitinfo[dir]" ]]; then
		gitinfo[msg]=""
		gitinfo[dir]=""
		return
	fi
	gitinfo[root]=$(git rev-parse --show-toplevel)
	gitinfo[bare]=$(git rev-parse --is-bare-repository)
	local branch_ref=$(git symbolic-ref HEAD 2>/dev/null)
	gitinfo[branch]=${branch_ref##*/}
	gitinfo[headname]=$c[br]$gitinfo[branch]
	if [[ -z $gitinfo[branch] ]]; then
		gitinfo[headname]="$c[br]$(git name-rev --name-only HEAD)"
		gitinfo[detached]="true"
	fi

	if [[ -n "$(git ls-files $gitinfo[root] --modified)" ]]; then
		gitinfo[dirty]="true"
	fi
	if git diff --quiet --cached 2>/dev/null; then; else
		gitinfo[staged]="true"
	fi
	if [[ -n $(git ls-files -u) ]]; then
		gitinfo[unmerged]="true"
	fi
	if [[ -n $(git ls-files --others --exclude-standard) ]]; then
		gitinfo[untracked]="true"
	fi

	if [[ -n $gitinfo[branch] ]]; then
		local remote=$(git config branch.$gitinfo[branch].remote)
		if [[ -n $remote ]]; then
			local merge=$(git config branch.$gitinfo[branch].merge)
			merge=${merge##refs/heads/}
			if [[ $remote != "." ]]; then
				merge=$remote/$merge
			fi
			merge=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
			local -a behind ahead
			behind=($(git rev-list $gitinfo[branch]..$merge | wc -l))
			ahead=($(git rev-list $merge..$gitinfo[branch] | wc -l))
			# reset to master~1: master..origin/master has 1
			# add commit to master: origin/master..master has 1
			# add commit to master~1: both have 1
			local tracking_msg=""
			if [[ $ahead -eq 0 ]] && [[ $behind -eq 0 ]]; then
				tracking_msg+="$c[equal]->"
			else
				if [[ $ahead -gt 0 ]]; then
					tracking_msg+="$c[plus]+$ahead"
				fi
				if [[ $behind -gt 0 ]]; then
					tracking_msg+="$c[minus]-$behind"
				fi
			fi
			gitinfo[tracking_merge]="$c[br]$merge"
			gitinfo[tracking_msg]=$tracking_msg
		fi
	fi
	#gitinfo[headtag]git
	local g=$gitinfo[dir]
	if [ -f "$g/rebase-merge/interactive" ]; then
		gitinfo[op]="rb -i"
		gitinfo[rb_head]=$(git name-rev --name-only $(cat "$g/rebase-merge/orig-head"))
		gitinfo[rb_onto]=$(git name-rev --name-only $(cat "$g/rebase-merge/onto"))
		gitinfo[op_msg]="$gitinfo[rb_onto]..$gitinfo[rb_head]"
	elif [ -d "$g/rebase-merge" ]; then
		gitinfo[op]="rb -m"
		gitinfo[rb_head]=$(cat "$g/rebase-merge/head-name")
		gitinfo[op_msg]="on $gitinfo[rb_head]"
	else
		if [ -d "$g/rebase-apply" ]; then
			if [ -f "$g/rebase-apply/rebasing" ]; then
				gitinfo[op]="rb"
			elif [ -f "$g/rebase-apply/applying" ]; then
				gitinfo[op]="am"
			else
				gitinfo[op]="am/rb"
			fi
			gitinfo[op_msg]="on $gitinfo[headname]"
		elif [ -f "$g/MERGE_HEAD" ]; then
			gitinfo[op]="mrg"
			gitinfo[merge_head]=$(cat "$g/MERGE_HEAD")
			gitinfo[op_msg]="$(git name-rev --name-only $gitinfo[merge_head]) into $gitinfo[headname]"
		elif [ -f "$g/CHERRY_PICK_HEAD" ]; then
			gitinfo[op]="chrypck"
			gitinfo[cp_head]=$(cat "$g/CHERRY_PICK_HEAD")
			gitinfo[op_msg]="from $(git name-rev --name-only $gitinfo[cp_head]) onto $gitinfo[headname]"
		elif [ -f "$g/BISECT_LOG" ]; then
			gitinfo[op]="bs"
			gitinfo[bs_start]=$(cat "$g/BISECT_START")
			gitinfo[op_msg]="from $gitinfo[bs_start] on $gitinfo[headname]"
		else
			if [[ -n $gitinfo[detached] ]]; then
				gitinfo[op]="dtch"
			else
				gitinfo[op]="on"
			fi
			gitinfo[op_msg]="$gitinfo[headname]"
			if [[ -n "$gitinfo[tracking_msg]" ]]; then
				gitinfo[op_msg]+=" $gitinfo[tracking_msg] $gitinfo[tracking_merge]"
			fi
		fi
	fi
	if [[ $gitinfo[op] == "on" ]]; then
		gitinfo[op]="$c[none]$gitinfo[op]"
	else
		gitinfo[op]="$c[halt]$gitinfo[op]"
	fi
	gitinfo[msg]=" $gitinfo[op] $gitinfo[op_msg]"
}

gitinfo_update

git_status() {
	if [[ -z $gitinfo[dir] ]]; then
		return
	else
		echo -n " $gitinfo[op] $gitinfo[op_msg]"
	fi
}

is_git() {
	if [[ -z $gitinfo[dir] ]]; then
		return 1
	else
		return 0
	fi
}

git_path() {
    if is_git; then
        if [[ -z $gitinfo[dirty] ]]; then
            if [[ -z $gitinfo[staged] ]]; then
                color=%F{green}
            else
                color=%F{yellow}
            fi
        else
            color=%F{red}
        fi
        local root=$gitinfo[root]
        echo ${${${$(print -P %d)/${root}/${root:h}/${color}${root:t}%F{cyan}}/${HOME}/\~/}/\/\//\/}
    else
        echo $(print -P %~)
    fi
}

gitinfo_preexec() {
    if [[ $2 =~ '(.*)git (.*)' ]]; then
        # Don't update if git status, git ls, etc.
        local args=$match[2]
        if [[ $args =~ '(status|ls|ls-files|log|lg|shortlog|last|diff|diffstat|show).*' ]]; then
        else
            gitinfo[do_update]=1
        fi
	fi
}

gitinfo_precmd() {
	if [[ "$gitinfo[do_update]" -eq 1 ]]; then
		gitinfo[do_update]=0
		gitinfo_update
	fi
}

add-zsh-hook chpwd gitinfo_update
add-zsh-hook preexec gitinfo_preexec
add-zsh-hook precmd gitinfo_precmd

PS1='%F{yellow}[%T%F{cyan}%1(j.%%%F{green}%j%F{cyan}.)%0(?..:%F{red}%B%?%b)%F{yellow}]%F{cyan}%# %f'
RPS1='%100>..>%F{cyan}%n%f%B@%b%F{cyan}%m%f%B:%b%<<%F{cyan}$(git_path)$gitinfo[msg]%b%k%f'

