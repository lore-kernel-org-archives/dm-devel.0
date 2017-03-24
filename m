From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: arrange compilation options
	for binaries
Date: Fri, 24 Mar 2017 14:52:35 +0100
Message-ID: <c169d960-8f0d-7f2a-7ac3-6efa4dbb765e@gmail.com>
References: <20170317224002.8967-1-xose.vazquez@gmail.com>
	<CABr-GndoZc+maRDaerfgUupPw4TeSgzf+aF9gZh0VNtKsjfQCA@mail.gmail.com>
	<CABr-GnfmGzcnW0GcqMLWs0Zg30Txw0k+3Er6zyrRpRrmcN-gwQ@mail.gmail.com>
	<20d24d9d-566f-cd2b-8f45-86167ffdd0df@gmail.com>
	<CABr-GneY28F_bP=dpsQEAWZAreoT3dBzJcz5Pik2ZHHbk9F_rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GneY28F_bP=dpsQEAWZAreoT3dBzJcz5Pik2ZHHbk9F_rA@mail.gmail.com>
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

On 03/23/2017 03:55 PM, Christophe Varoqui wrote:

> Yes indeed, the build really failed on my box.
> 
> Toolchain versions :
> * gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.2) 
> * GNU ld (GNU Binutils for Ubuntu) 2.26.1

In Fedora 25, with these packages, it's built flawlessly:
kernel-4.10.5
binutils-2.26.1
glibc-2.24
make-4.1
gcc-6.3.1
clang-3.9.1

>> And reverted:
>> hh
>> From http://eli.thegreenplace.net/2013/07/09/library-order-in-static-linking <http://eli.thegreenplace.net/2013/07/09/library-order-in-static-linking>:
>>
>>     If object or library AA needs a symbol from library BB, then AA should
>>     come /before/ library BB in the command-line invocation of the linker.
>

Maybe this limitation was fixed in newer releases.
