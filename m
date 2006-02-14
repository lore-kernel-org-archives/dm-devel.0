From: "Tom Kalus" <tkalus@us.xyratex.com>
Subject: multipath-tools changing an alias
Date: Tue, 14 Feb 2006 11:38:45 -0800
Message-ID: <DF112ECA4AC6564C934A2D2E2D57A07707B830@XYUS-EX22.xyus.xyratex.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Couple questions:


Is there a bug and enhancement tracking site for multipath-tools?
I saw a few postings on bugzilla at redhat; is there a less-obvious
place?


Is there a way to change an alias from the command line with
multipath-tools?=20
I saw that the assiciations were maintained in a flat file
(/var/cacahe/multipath/bindings), but I didn't see any way of changing
the alias without parsing/editing the file itself.
Am I just not looking in the right place (alias.c)? Or am I going to get
a "great feature, I await your patch."


Thanks,
Tom


Version: 0.4.6.latest (from kernel.org's git repo as of 2006-02-14 1900
+0000)
Where I'm expecting to see something: libmulitpath/alias.[ch]
=20

*
Tom Kalus II
Software Engineer
Xyratex International
San Jose, CA, USA
tkalus@us.xyratex.com=20
