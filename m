From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] [multipath-tools]'multipath' with -h and -t
 option, it returns '1' (fail) for successful command execution.
Date: Tue, 04 Oct 2011 19:52:15 +0200
Message-ID: <1317750735.6857.2.camel@lapoo.opensvc.com>
References: <1317706703.1886.132.camel@arunaltc>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1317706703.1886.132.camel@arunaltc>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: aruna <aruna@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On mar., 2011-10-04 at 11:08 +0530, aruna wrote:
> Hi,
> 
> The patch handles the exit status of -h and -t option for multipath
> command.
> 
You patch does not apply to the HEAD. And you should submit with patch
inline for "git am" to work and preserve your patch comment and
authorship.

Thanks,
cvaroqui

> # multipath -h
> multipath-tools v0.4.9 (05/33, 2016)
> Usage:
>   multipath [-d] [-r] [-v lvl] [-p pol] [-b fil] [dev]
>   multipath -l|-ll|-f [-v lvl] [-b fil] [dev]
>   multipath -F [-v lvl]
>   multipath -t
>   multipath -h
> 
> .......
> 
> # echo $?
> 1
> 
> 
> # multipath -t | more 
> defaults {
>         verbosity 2
>         polling_interval 10
>         udev_dir "/dev"
>         multipath_dir "/lib64/multipath"
>      ...
> }
> ...
> 
> 
> # echo $?
> 1
> 
> 
> Since kernel.org is unavailable i have got the recent snapshot from 
> 
> http://git.opensvc.com/?p=multipath-tools/.git;a=snapshot;h=f7735ad547d9ebb952993ac0a6def0400fb23c80;sf=tgz
> 
> 
> Thanks,
> Aruna Balakrishnaiah
> 
