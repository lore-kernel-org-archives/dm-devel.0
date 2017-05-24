From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 06/15] fs: simplify dio_bio_complete
Date: Wed, 24 May 2017 16:08:46 +0000
Message-ID: <1495642124.2823.11.camel@sandisk.com>
References: <20170518131812.22956-1-hch@lst.de>
         <20170518131812.22956-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170518131812.22956-7-hch@lst.de>
Content-Language: en-US
Content-ID: <50D1DD4786E2354494CFAFAACFCBECFB@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, 2017-05-18 at 15:18 +0200, Christoph Hellwig wrote:
> Only read bio->bi_error once in the common path.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
