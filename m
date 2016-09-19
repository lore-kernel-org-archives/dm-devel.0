From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-verity verification
Date: Mon, 19 Sep 2016 12:35:31 +0200
Message-ID: <066eb1d0-71ad-aff1-7aed-d4db0caad140@gmail.com>
References: <CANKSX+HxXiY5XgpMsk=DeQRYgntMiKH-2SLYzmD3ShTUM=NPtg@mail.gmail.com>
	<e02cf252-ca4e-4086-43fc-a308a6ad74e0@gmail.com>
	<CANKSX+FcNXZ7t21Sji4NN4R18WYt0cy0q7k+nWnpDoRUshOokA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CANKSX+FcNXZ7t21Sji4NN4R18WYt0cy0q7k+nWnpDoRUshOokA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: srikanth007m@gmail.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 09/17/2016 06:09 PM, $rik@nth  wrote:
> 
> On Sat, Sep 17, 2016 at 6:15 PM, Milan Broz <gmazyland@gmail.com
> <mailto:gmazyland@gmail.com>> wrote:
> 
> (Just it does not understand current FEC extensions yet, patch for
> this
> 
> 
> Any patches available to apply locally and verify with FEC
> extensions? How generally the verity can be tested to ensure it is
> working as expected (I pulled upstream verity changes and build a
> kernel). Any dd tests can be sufficient to check the things are
> working fine.

There is wip-fec branch in upstream cryptsetup git but it need a lot
of work - no guarantees it even works.
(There are no tests for FEC in that branch yet, it only patches veritysetup.)

Milan
