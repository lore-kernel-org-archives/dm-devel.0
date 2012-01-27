From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: dd to a striped device with 9 disks gets much lower
 throughput when oflag=direct used
Date: Fri, 27 Jan 2012 07:03:00 -0800
Message-ID: <CACyXjPz1mKXtCnRnzVDotOES9QaD0kLKBP_r_GWe_FrgZq0g3g@mail.gmail.com>
References: <CACyXjPzWjBz0=btbL0Gx_qoxRQs7wy9m=dY1--xL29uszTpmFA@mail.gmail.com>
	<20120127085226.GA16520@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120127085226.GA16520@infradead.org>
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

On Fri, Jan 27, 2012 at 12:52 AM, Christoph Hellwig <hch@infradead.org> wro=
te:
> On Thu, Jan 26, 2012 at 05:06:42PM -0800, Richard Sharpe wrote:
>> Why do I see such a big performance difference? Does writing to the
>> device also use the page cache if I don't specify DIRECT IO?
>
> Yes. =A0Trying adding conv=3Dfdatasync to both versions to get more
> realistic results.

Thank you for that advice. I am comparing btrfs vs rolling my own
thing using the new dm thin-provisioning approach to get something
with resilient metadata, but I need to support two different types of
IO, one that uses directio and one that can take advantage of the page
cache.

So far, btrfs gives me around 800MB/s with a similar setup (can't get
exactly the same setup) without DIRECTIO and 450MB/s with DIRECTIO. a
dm striped setup is giving me about 10% better throughput without
DIRECTIO but only about 45% of the performance with DIRECTIO.

Anyway, I now understand. I will run my scripts with conv=3Dfdatasync as we=
ll.

-- =

Regards,
Richard Sharpe
