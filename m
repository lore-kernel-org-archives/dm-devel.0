From: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: [RFC][PATCH] dm-cache: block level disk cache target
	for device mapper
Date: Thu, 30 Nov 2006 10:24:27 -0600
Message-ID: <a4e6962a0611300824qdfa43cbja783da86fe6eb5cf@mail.gmail.com>
References: <200611271826.kARIQYRi032717@hera.kernel.org>
	<200611301232.57966.jens.wilke@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200611301232.57966.jens.wilke@de.ibm.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Eric Van Hensbergen <ericvh@hera.kernel.org>, ming@acis.ufl.edu, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 11/30/06, Jens Wilke <jens.wilke@de.ibm.com> wrote:
> On Monday 27 November 2006 19:26, Eric Van Hensbergen wrote:
>
> If this is intended to speed up remote disks, is it possible that the cache content
> can be paged out on local disks in low-mem situations?
>

The main intent was to use local disks as cache to offload centralized
remote disks.  The logic was that most systems have local disks, if
only for swap -- so why not use them as a cache to help offload
centralized storage.  While the in-memory page cache works perfectly
fine in certain situations -- we were dealing with workloads in which
the in-memory page-cache wasn't sufficient to hold all the data.

There are also some additional possibilities we've thought through and
have been playing with including allowing the local disk cache to be
persistent across reboots (with varying validation schemes).

             -eric
