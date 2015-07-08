From: Joe Thornber <thornber@redhat.com>
Subject: Re: DM-Cache Writeback & Direct IO?
Date: Wed, 8 Jul 2015 15:48:29 +0100
Message-ID: <20150708144829.GA5058@rh-vpn>
References: <559CE76E.6020504@evilazrael.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <559CE76E.6020504@evilazrael.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Wed, Jul 08, 2015 at 11:03:42AM +0200, Christoph Nelles wrote:
> Hi,
> 
> Can the dm-cache writeback cache buffer direct IO or goes direct IO
> always immediately to the origin device?

Yes, the device mapper layer knows nothing about direct IO vs page
cache IO.

> I am currently performing tests and see that random direct write IO
> never hits the cache, even after overwriting the same region over
> and over.

Could you try with the latest kernels and the new smq policy please?

- Joe
