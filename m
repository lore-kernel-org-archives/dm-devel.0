From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 17:53:59 +0000
Message-ID: <20071211175359.GV22311@agk.fab.redhat.com>
References: <1197389316.25082.27.camel@quest>
	<3ae72650712110935n20398423t1da02c585a72aead@mail.gmail.com>
	<1197394828.25082.39.camel@quest>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1197394828.25082.39.camel@quest>
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
Cc: linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids

On Tue, Dec 11, 2007 at 05:40:28PM +0000, Scott James Remnant wrote:
>  1) udev creates device node and sets permissions
>  2) devmapper no-ops since it already exists
 
...because libdevmapper has no notion that something other than itself
could have created it.  That's a bug, but provided the proper udev
integration isn't much longer in coming, I shan't bother to fix it.

Alasdair
-- 
agk@redhat.com
