From: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: [RFC][PATCH] dm-cache: block level disk cache target
	for device mapper
Date: Mon, 11 Dec 2006 12:54:33 -0600
Message-ID: <a4e6962a0612111054j6741c70cja1aa96ebee124e63@mail.gmail.com>
References: <200611271826.kARIQYRi032717@hera.kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200611271826.kARIQYRi032717@hera.kernel.org>
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
To: Eric Van Hensbergen <ericvh@hera.kernel.org>
Cc: dm-devel@redhat.com, ming@acis.ufl.edu, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 11/27/06, Eric Van Hensbergen <ericvh@hera.kernel.org> wrote:
> This is the first cut of a device-mapper target which provides a write-back
> or write-through block cache.  It is intended to be used in conjunction with
> remote block devices such as iSCSI or ATA-over-Ethernet, particularly in
> cluster situations.
>

The technical paper describing our motivations and some performance
results has finally made it through IBM's clearance process.  It is
available here:

http://domino.research.ibm.com/library/cyberdig.nsf/1e4115aea78b6e7c85256b360066f0d4/ba52bef8b940e7438525723c006bafea?OpenDocument

               -eric
