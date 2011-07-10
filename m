From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Device removal handling
Date: Sun, 10 Jul 2011 23:03:30 +0100
Message-ID: <20110710220330.GA7857@agk-dp.fab.redhat.com>
References: <4E1A079A.9060901@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E1A079A.9060901@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Phillip Susi <psusi@cfl.rr.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

If you want to remove a dm device forcibly, replace it with an 'error' target
that will return I/O errors.  (dmsetup remove -f)

(But devices should be removed from the top down, obviously, and if
it's your main filesystem, you could e.g. set up a ramdisk do do
this from.)

Alasdair
