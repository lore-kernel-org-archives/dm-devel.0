From: "Ming Zhao" <mingzhao99th@gmail.com>
Subject: Re: Re: [RFC][PATCH] dm-cache: block level disk cache
	target for device mapper
Date: Sat, 2 Dec 2006 13:28:06 -0500
Message-ID: <b1e142760612021028t522ba3ffs485bc70d93a85774@mail.gmail.com>
References: <200611271826.kARIQYRi032717@hera.kernel.org>
	<20061127184748.GA11219@outpost.ds9a.nl>
	<a4e6962a0611271155q55adf6fftd489de84d6ae7e88@mail.gmail.com>
	<1165022497.2761.216.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1165022497.2761.216.camel@localhost.localdomain>
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
To: blackmagic02881@gmail.com
Cc: device-mapper development <dm-devel@redhat.com>, ming@acis.ufl.edu, Linux Kernel <linux-kernel@vger.kernel.org>, bert hubert <bert.hubert@netherlabs.nl>
List-Id: dm-devel.ids

On 12/1/06, Ming Zhang <blackmagic02881@gmail.com> wrote:
> like to see this idea but any similarity with
> http://www.ele.uri.edu/Research/hpcl/STICS/stics.pdf?
>
> STICS is patent pending so not sure if kernel can be free to merge this
> dm-cache.

I like the idea of STICS, an efficient bridge between SCSI and IP. But
I think its only similarity with dm-cache is the use of nonvolatile
caching.

Dm-cache is a generic block-level disk cache that supports a variety
of SAN technologies and is not tied to any particular one.


Best regards,
Ming Zhao
