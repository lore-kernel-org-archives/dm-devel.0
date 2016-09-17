From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-verity verification
Date: Sat, 17 Sep 2016 14:45:42 +0200
Message-ID: <e02cf252-ca4e-4086-43fc-a308a6ad74e0@gmail.com>
References: <CANKSX+HxXiY5XgpMsk=DeQRYgntMiKH-2SLYzmD3ShTUM=NPtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CANKSX+HxXiY5XgpMsk=DeQRYgntMiKH-2SLYzmD3ShTUM=NPtg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: srikanth007m@gmail.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On 09/17/2016 06:58 AM, $rik@nth  wrote:
> Hi,
> 
> Is there any suite or tests available to test the dm after enabling
> for the first time on the kernel after making some changes. Please
> help in pointing if any such are available.

cryptsetup source code contains very simple test (for veritysetup)
but this is more intended to check that kernel-userspace interface
works (for various settings).

veritysetup also provides userspace-only verification (see verify command).
(Just it does not understand current FEC extensions yet, patch for this
will be merged in next major release.)

Milan
