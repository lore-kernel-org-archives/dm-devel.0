From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: trouble with generic/081
Date: Fri, 16 Dec 2016 10:31:21 +0100
Message-ID: <eb44e057-6d93-1549-5399-eae0c71c1ed9@redhat.com>
References: <20161214164314.GA25105@infradead.org>
	<20161215063650.GJ4326@dastard> <20161215084224.GA14395@infradead.org>
	<c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
	<20161216081523.GA13847@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161216081523.GA13847@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Dne 16.12.2016 v 09:15 Christoph Hellwig napsal(a):
> On Thu, Dec 15, 2016 at 10:16:23AM +0100, Zdenek Kabelac wrote:
>> So let me explain the logic behind this 'amazingly stupid' idea.
>
> And that logic doesn't make any sense at all.  invibly unmounting
> a file system behind the users back is actively harmful, as it is
> contradicting the principle of least surprise, and the xfstests mess
> is one simple example for it.  Add a callback in-kernel to tell the
> fs to shut down but NOT unmount and expose the namespace below it,
> which the administrator has probably intentionally hid.
>
> Even worse unmount may trigger further writes and with fses not
> handling them the fs might now be stuck after being detached from
> the namespace without a way for the admin to detect or recover this.
>
> What XFS did on IRIX was to let the volume manager call into the fs
> and shut it down.  At this point no further writes are possible,
> but we do not expose the namespace under the mount point, and the
> admin can fix the situation with all the normal tools.
>

Please propose something better.
(do nothing is NOT better)

Regards


Zdenek
