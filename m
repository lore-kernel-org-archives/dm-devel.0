From: "David Guyon Martin" <david.guyonmartin@gmail.com>
Subject: Re: device mapper integrated loops - and one more year !
Date: Fri, 6 Oct 2006 11:38:12 +0200
Message-ID: <2c53b31c0610060238nef13171ma6f4a42ba755c3b0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 5 Oct 2006 20:40:05 +0100 Alasdair G Kergon wrote:

>Something like:
>  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-loop.patch
>now perhaps?

>(And there are patches for dmsetup to become a drop-in losetup replacement.)

Yes! This patch add a new file to the kernel tree, dm-loop.c:
"This implements a loopback target for device mapper allowing a regular
file to be treated as a block device."

Great !!! At last :)
It seems this dm-loop is quite new, less than a month...
As I understand it I need kernel 2.6.18-rc7 to use it, right ?

I really thank you a lot for your quick answer and link.

Does anyone has yet a feedback about this dm-loop ?

David G.M.
