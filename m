From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RHEL 6: Missing /dev/mpath directory
Date: Fri, 6 May 2011 13:47:45 -0400
Message-ID: <20110506174745.GA26776@redhat.com>
References: <BANLkTimUvQu8zhLSyxiO3TP-uVV9Z4NEvQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <BANLkTimUvQu8zhLSyxiO3TP-uVV9Z4NEvQ@mail.gmail.com>
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

On Fri, May 06 2011 at  1:13pm -0400,
MOHAMMED FIRDOSH NASIM <firdosh.nasim@gmail.com> wrote:

> Hi,
> Apologies, as I am not sure whether my query fits into this mailing list. If
> not, then please direct me to the correct mailing list.
> 
> I have configured RHEL 6 X86_64 host and have enabled multipath. As per the
> DM Multipath documentation at "
> http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/DM_Multipath/mpath_devices.html#multipath_device_id",
> 
> 
> "When new devices are brought under the control of DM-Multipath, the new
> devices may be seen in three different places under the /dev directory:
> /dev/mapper/mpath*n*, /dev/mpath/mpath*n*, and /dev/dm-*n*. "
> 
> In my host I am seeing the devices only as /dev/dm-n and /dev/mapper/mpathx
> symlink to /dev/dm-n. I am not seeing directory /dev/mpath.
> ---------------------------- screen dump start ---------------------------
> [root@sped10 ~]# cat /etc/issue
> Red Hat Enterprise Linux Server release 6.0 (Santiago)
> Kernel \r on an \m
> 
> [root@sped10 ~]# uname -a
> Linux sped10 2.6.32-71.el6.x86_64 #1 SMP Wed Sep 1 01:33:01 EDT 2010 x86_64
> x86_64 x86_64 GNU/Linux
> [root@sped10 ~]# ls -l /dev/mapper/ | grep mpath
> lrwxrwxrwx. 1 root root      7 May  6 22:34 mpatha -> ../dm-7
> lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathb -> ../dm-8
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathc -> ../dm-13
> lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathd -> ../dm-6
> lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathe -> ../dm-4
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathf -> ../dm-10
> lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathg -> ../dm-5
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathh -> ../dm-12
> lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathi -> ../dm-9
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathj -> ../dm-11
> lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathk -> ../dm-2
> lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathl -> ../dm-3
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathlp1 -> ../dm-16
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathm -> ../dm-15
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathmp1 -> ../dm-20
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathmp2 -> ../dm-21
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathmp3 -> ../dm-22
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathn -> ../dm-14
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathnp1 -> ../dm-17
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathnp2 -> ../dm-18
> lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathnp3 -> ../dm-19
> [root@sped10 ~]# ls /dev/mpath
> ls: cannot access /dev/mpath: No such file or directory
> [root@sped10 ~]#
> 
> ---------------------------- screen dump end   ---------------------------
> 
> Am I missing something in configuring multipath? Please assist in this
> regard.

Seems we need to update the RHEL6 docs you referenced.

/dev/mpath/ namespace is no longer maintained (afaik it was a "feature"
of a udev rule.  But I could be mistaken.  Ben and/or others could
correct me if I'm wrong).

/dev/mapper/mpath* was always the preferred method of access (even when
/dev/mpath/* did exist) -- reason is it was always available regardless
of udev.
