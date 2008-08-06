From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Status of resizing/growing dm-multipath devices on the
	fly
Date: Wed, 6 Aug 2008 15:53:55 +0300
Message-ID: <20080806125355.GM3771@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hello!

Is it possible to resize (grow) dm-multipath devices on the fly nowadays? 

I googled and found some discussions about the subject, but the conclusion
seemed to be it's not possible.. that was a while ago, so I was wondering if
this has been fixed/implemented.. 

Using LVM and adding another new LUN/PV is not an option always.. it's a lot
easier to manage the whole thing if it's possible to resize/grow existing
LUNs on the fly.

Thanks!

-- Pasi
