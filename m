From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 01/15] nvme-lightnvm: use blk_execute_rq in
 nvme_nvm_submit_user_cmd
Date: Wed, 24 May 2017 15:50:18 +0000
Message-ID: <1495641016.2823.6.camel@sandisk.com>
References: <20170518131812.22956-1-hch@lst.de>
         <20170518131812.22956-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170518131812.22956-2-hch@lst.de>
Content-Language: en-US
Content-ID: <476E2C4750EA1B4B9A3C495F5A6F2EC3@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, 2017-05-18 at 15:17 +0200, Christoph Hellwig wrote:
> Instead of reinventing it poorly.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
