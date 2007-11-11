From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Error in /avr/log/messages when starting multipath-tools
Date: Sun, 11 Nov 2007 15:39:26 +0100
Message-ID: <1194791966.5831.2.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi... 

I get the following error when starting multipath-tools with the RDAC
checker:

multipathd[3342]: segfault at ffffffff00559998 rip 00002b5dafb2c969 rsp
00007ffffb6c0e50 error 4

I run a 2.6.23.1 kernel by the way. Is this error something serious? An
if so, can I do something about it?

Here's my multipath.conf:

devices {
        device {
                vendor                  "DELL"
                product                 "MD3000"
                getuid_callout          "/sbin/scsi_id -g -u -s /block/%
n"
                prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
                features                "0"
                hardware_handler        "1 rdac"
                path_grouping_policy    group_by_prio
                failback                30
                path_checker            rdac
        }
}

Thanks,

Sander
