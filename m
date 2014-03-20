From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: multipath-tools: race condition between 'mutipath -r'
 and multipathd path checker causing segfault
Date: Thu, 20 Mar 2014 16:44:06 +0000
Message-ID: <FB8A412F33166C4A930D37BD63236C902AD70599@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi All, 

We found a strange issue with race between multipathd and "multipath -r" which causes segfault.  Below are the sequence of operations that are leading to this.

1. Configure system with multipath and iSCSI connection. Enable paths to both controller ( rdac  prio values 14 and 9  and group_by_prio is the pg policy).
2. Fail one of the connection to multipath device. ( physical paths transition to running->blocked->transport-offine and multipathd puts them in faulty/offline state ).
3. Run "multipath -r".
4. All faulty paths are removed from dm device and maps are reloaded with only good paths. ( as open() call on faulty devices fails with ENXIO during pathinfo() )
5. multipathd: update_multipath_strings() called during check_path will update/removes path_groups based on info from libdevmapper().
6. When failed connection is restored. Devices are placed in Running state again and path checker calls enable_group() on path group which has been freed and causes segfault.

Mar 17 22:36:56 ictm-rediff kernel: multipathd[12405]: segfault at 8 ip 00000000004077f9 sp 00007fb6a94e2cf0 error 4 in multipathd[400000+10000]

Not only segfault, but this also leads to issue switching to path group which is no longer present  in kernel.

Mar 17 22:36:44 ictm-rediff multipathd: 360080e500034173900008ca45307fd63: switch to path group #2
Mar 17 04:13:41 ictm-rediff kernel: device-mapper: multipath: invalid PG number supplied to switch_pg_num

So,  calling "multipath -r" is really recommended when faulty paths are present in system?. Is this a limitation?. Can multipathd deal with these scenarios?.

Thanks
Shiva
