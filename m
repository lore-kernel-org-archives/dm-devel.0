From: Petteri Heinonen <petteri.j.heinonen@kolumbus.fi>
Subject: RE: I/O error during path failover
Date: Tue, 28 Nov 2006 11:41:02 +0200 (EET)
Message-ID: <31167844.735111164706862589.JavaMail.petteri.j.heinonen@kolumbus.fi>
Reply-To: petteri.j.heinonen@kolumbus.fi,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; Charset=iso-8859-1; Format=Flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

and thanks for the help.
I also noticed that "group_by_prio" issue, will change to that. 

Also, the actual problem of IO errors seems to be solved by now. The problem was in my own script, which is used to restore the paths after a failed path comes back. As the system is running OCFS2 on those multipathed LUNs, we need to have a constant knowledge over all nodes of the cluster about the states of the paths, before default paths can be restored. There was a bug in that script, causing it to try path restoration even though all paths in all nodes were actually not accessible yet. I also fixed this, and it looks much better now.

But couple of additional questions. I have tried to specify that additional feature "queue_if_no_path" in several places in multipath.conf, but no matter where I specify it, it does not appear in "multipath -ll" nor "dmsetup table" outputs. Is there some known bug in RHEL4u4 for this?

I have also tried to specify parameter no_path_retry with several  different values, but it doesn't change the output of "dmsetup table" in any way. Is this ok? I guess that there should be some visible changes in "dmsetup table", as dm_* kernel modules do not read multipath.conf directly, do they?

-Petteri

Edward Goggin <egoggin@emc.com> kirjoitti: 
> On Sunday, November 26, 2006 8:27 AM, Petteri Heinonen wrote
> 
> > I have a system with Qlogic QLA2312 HBAs. System is running RHEL 4u4:
> > 
> > [root@cpn-0 etc]# uname -a
> > Linux cpn-0.chas1A.ucs2.net 2.6.9-42.ELsmp #1 SMP Wed Jul 12 
> > 23:27:17 EDT 2006 i686 i686 i386 GNU/Linux
> > [root@cpn-0 etc]# rpm -qa | grep device
> > device-mapper-1.02.07-4.0.RHEL4
> > device-mapper-multipath-0.4.5-18.1.RHEL4
> > [root@cpn-0 etc]#
> > 
> > Storage is EMC Cx500. Multipath.conf is at the end of the 
> > mail. I have tested the system by running I/O directly to 
> > multipath device file, e.g. like this:
> > 
> > dd if=/dev/mpath/dm-0 of=/dev/null count=10000000
> > 
> > Now, when I pull the cable to cause path change, dd usually 
> > stops in the middle, and gives error message indicating I/O 
> > error. Any suggestions?
> >
> 
> The CLARiiON should only be configured with a dm-multipath path
> grouping policy of "group_by_prio".
> 
> Using a no_path_retry value of "fail" may prevent a CLARiiON ucode
> from being updated in an application transparent manner.  Should set
> CLARiiON features to "1 queue_if_no_path".
