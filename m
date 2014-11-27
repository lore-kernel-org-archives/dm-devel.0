From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 18:04:01 +0100
Message-ID: <54775981.1020803@redhat.com>
References: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>	<54773621.5090301@redhat.com>	<CAG2kNCyDcgCdCpUAzZ51mAyqS8LF9i9Tau3Lke5E2ZJy352_ig@mail.gmail.com>	<54774220.7080709@redhat.com>	<CAG2kNCz7hmtcMQBeVQRbryVTzsE_DKr9y8Pg8rfKmSf8UDVDRQ@mail.gmail.com>	<5477469A.1080103@redhat.com>	<CAG2kNCz_SKbHc4b56L1Dzkb19HsozW9aKs1Ln4MmYY9iUiLJOg@mail.gmail.com>	<54774BCC.6020709@redhat.com>	<CAG2kNCz=KuBKcLog-Z=iZBNAg9J31KwFRa7RgJ0GLXNqsd4UYQ@mail.gmail.com>	<547752E4.70304@redhat.com>
	<CAG2kNCzQOo8OYTLdLDeUpGN3wNJQWv-ibGxUAxMnQBtQq-r3kw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCzQOo8OYTLdLDeUpGN3wNJQWv-ibGxUAxMnQBtQq-r3kw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 27.11.2014 v 17:46 Gianluca Cecchi napsal(a):
> On Thu, Nov 27, 2014 at 5:35 PM, Zdenek Kabelac <zkabelac@redhat.com
> <mailto:zkabelac@redhat.com>> wrote:
>
>
>
>     As I've been pointed our cgroups could play some role -
>
>
> mhh I don't think I'm using Control Groups at all....
> [root@orapr2 ~]# rpm -qa |grep group
> [root@orapr2 ~]#
>
> [root@orapr2 ~]# ll /etc/cgconfig.conf
> ls: cannot access /etc/cgconfig.conf: No such file or directory
>
>
>     so lets repeat with  /proc/*/mountinfo
>
>
> [root@orapr2 ~]# cat /proc/*/mountinfo > /tmp/proc.log
> cat: /proc/33700/mountinfo: Invalid argument
> cat: /proc/33735/mountinfo: No such file or directory
>
> [root@orapr2 ~]# wc -l /tmp/proc.log
> 55050 /tmp/proc.log
>
>   [root@orapr2 ~]# grep 253:49 /tmp/proc.log
> [root@orapr2 ~]#
>
>
>     Also check  /proc/swaps ?
>
>
>   [root@orapr2 ~]# cat /proc/swaps
> FilenameTypeSizeUsedPriority
> /dev/sda2                               partition167772120-1
>

So I'm afraid you will need to open a RHEL support ticket to get all the 
diagnostic  (sosreport)  -  since if this is production system,
all further advices may lead to some problems.

Zdenek
