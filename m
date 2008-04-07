From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: Desynchronizing dm-raid1
Date: Mon, 07 Apr 2008 13:44:27 -0400
Message-ID: <yq1zls5muf8.fsf@sermon.lab.mkp.net>
References: <20080317215631.GG29322@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181921380.10939@porkchop.devel.redhat.com>
	<20080318233955.GA12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181942140.20490@porkchop.devel.redhat.com>
	<20080319000241.GB12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803182015001.21077@porkchop.devel.redhat.com>
	<20080319011757.GD12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0804021444120.22485@porkchop.devel.redhat.com>
	<20080403014042.GA3789@us.ibm.com>
	<yq14padoast.fsf@sermon.lab.mkp.net>
	<20080407172230.GA11600@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080407172230.GA11600@us.ibm.com> (malahal@us.ibm.com's message
	of "Mon\, 7 Apr 2008 10\:22\:30 -0700")
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

>>>>> "Malahal" == malahal  <malahal@us.ibm.com> writes:

Malahal> Your problem is very similar to an iSCSI problem sumitted
Malahal> here:
Malahal> http://now.netapp.com/NOW/cgi-bin/bol?Type=Detail&Display=137902

Can't see it without a netapp account...


Malahal> Fortunately, you can detect the problem and the I/O can be
Malahal> retried if possible.

That's not entirely trivial.  Obviously the original data that matches
the checksum is gone.  And I don't want to blindly regenerate the
checksum from the new data (how do I know this was an "ok" kind of
corruption?).

The only one that has that knowledge is the filesystem.  And if the
filesystem needs to be integrity-aware, I'd much rather have it Do The
Right Thing than teach it to inspect and reissue I/Os that come back
with -EDANGERWILLROBINSON.

With ext2 at least this is not some rare corner case.  It happens
hundreds of times during an unpack of a kernel tarball.  We'd end up
burning many, many cycles doing retries.

-- 
Martin K. Petersen	Oracle Linux Engineering
