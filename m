From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: 4k block LUN problem
Date: Wed, 13 Jun 2007 19:56:51 +0100
Message-ID: <20070613185651.GF18457@agk.fab.redhat.com>
References: <1888A5CA2B0AD311AD520090274069940AA82789@usbmaxms02.am.sony.com>
	<3DB43EBAF77555449D828440C12F8E7E0332E31C@usbmaxms02.am.sony.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3DB43EBAF77555449D828440C12F8E7E0332E31C@usbmaxms02.am.sony.com>
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

Try using an alternative path checker like tur or directio.

readsector0 seems to have '512' hard-coded - this ought to get fixed.

Alasdair
-- 
agk@redhat.com
