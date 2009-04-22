From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [RFC] dm snapshot based asynchronous replication
Date: Wed, 22 Apr 2009 23:20:18 +0200
Message-ID: <1240435218.492.29.camel@plop>
References: <137413921.2150341239820262767.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<1046537454.2150461239820304817.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<20090416070213.GA7566@johann>
	<540AD48B-A810-4F15-BEA0-5879350EA893@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <540AD48B-A810-4F15-BEA0-5879350EA893@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


> It also seems that the script is not generic enough to handle the  
> variety of exception stores that are coming.  I just wrote a 'snapshot- 
> merge' target that will do what you ask.  I will post the patch  
> shortly.  However, this won't help you in RHEL5.
> 
Jonathan,

thank you for this new snapshot-merge target. This plus the shared
exception patches will certainly bring the definitive answer for
LVM2-based replication/backup/time-navigation needs for RHEL6. I hope
btrfs will even bring to the table an interesting alternative sometime
in the el6 lifecycle.

But for those stuck with (entitlements on thousands of) el4 and el5
deployments, here is my contribution to the poor-man's async
replication :

http://christophe.varoqui.free.fr/rcow/

* rcow.pl
parse a cow device to generate a delta-file of 2 snapshots

* rcowd
handles full sync of remote device and schedule (one-shot or loop) :
- delta-file creation
- snapshot rotation
- delta-file sending to remote
- delta-file load on remote


Todo:
- more error checking
- sequencing cookies :
  o store on remote the last delta-file cookie succesfully loaded
  o store {prev_cookie, this_cookie} in delta_files
  o verify on remote that delta-file(prev_cookie)==last applied cookie
- replace the dd plumbing, though the readability of delta-file +
command-file is quite nice for understanding what happen (and may go
wrong). May be port to C.
- delta-file historization and rotation


Comments and contributions welcome.

Regards,
cvaroqui
