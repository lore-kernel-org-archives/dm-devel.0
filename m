From: Matthias Kranz <mkranz@redhat.com>
Subject: Re: qla2xxx and lun issue
Date: Wed, 13 Dec 2006 11:26:08 +0100
Message-ID: <1166005568.3222.11.camel@localhost.localdomain>
References: <457F3F3C.7040106@ucalgary.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <457F3F3C.7040106@ucalgary.ca>
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

On Tue, 2006-12-12 at 16:46 -0700, Daryl Fenton wrote:
> Is there any way to just blacklist all 
> things of type LUN Z?

Try adding

bl_product              "LUNZ"

to /etc/multipath.conf.

Cheers,
Matthias
-- 
Matthias Kranz                      Email: mkranz@redhat.com
Learn. Network. Experience open source.
Red Hat Summit San Diego  |  May 9-11, 2007
Learn more: http://www.redhat.com/promo/summit/2007
