From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: arrange compilation options
	for binaries
Date: Thu, 23 Mar 2017 15:02:40 +0100
Message-ID: <20d24d9d-566f-cd2b-8f45-86167ffdd0df@gmail.com>
References: <20170317224002.8967-1-xose.vazquez@gmail.com>
	<CABr-GndoZc+maRDaerfgUupPw4TeSgzf+aF9gZh0VNtKsjfQCA@mail.gmail.com>
	<CABr-GnfmGzcnW0GcqMLWs0Zg30Txw0k+3Er6zyrRpRrmcN-gwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GnfmGzcnW0GcqMLWs0Zg30Txw0k+3Er6zyrRpRrmcN-gwQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/23/2017 10:09 AM, Christophe Varoqui wrote:

> And reverted:
> hh
> From http://eli.thegreenplace.net/2013/07/09/library-order-in-static-linking:
> 
>     If object or library AA needs a symbol from library BB, then AA should
>     come /before/ library BB in the command-line invocation of the linker.

Did you get a toolchain error?
