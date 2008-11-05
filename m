From: Domenico Viggiani <dviggiani@tiscali.it>
Subject: dm-multipath with Celerra iSCSI
Date: Wed, 5 Nov 2008 12:23:08 +0100
Message-ID: <8091EF5D0CFB498CABAFC1A9B92E9F3E@pitagora.it>
References: <20081105005507.GH14593@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081105005507.GH14593@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,
I configured an iSCSI LUN on an EMC Celerra NAS. After discovered LUN by
iSCSI and ran "multipath -v2", I get:

# multipath -ls
mpath-resize-test (36006048ca49317821e436e3a5ab974f6) dm-3 EMC,Celerra iSCSI
[size=295G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][enabled]
 \_ 10:0:0:52 sda 8:0   [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 11:0:0:52 sdb 8:16  [active][undef]

# multipath -ll
mpath-resize-test (36006048ca49317821e436e3a5ab974f6) dm-3 EMC,Celerra iSCSI
[size=295G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][enabled]
 \_ 10:0:0:52 sda 8:0   [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 11:0:0:52 sdb 8:16  [active][ready]

Why is there difference between two outputs?

Then, examining "multipath -v3" output, I see "path checker = readsector0";
is it right?

In general, are multipath.conf defaults right for this Celerra filer?

Thanks in advance
--
Domenico Viggiani
