From: Milan Broz <mbroz@redhat.com>
Subject: Re: dm_crypt: very low performance of random IO
	operations
Date: Tue, 07 Sep 2010 22:06:35 +0200
Message-ID: <4C869B4B.706@redhat.com>
References: <4C80B1B9.6040809@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C80B1B9.6040809@gmail.com>
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

On 09/03/2010 10:28 AM, Yakov Hrebtov wrote:
> I'm experirncing problems with performance of random IO operations of 
> dm_crypt-encrypted devices.
> Sequential IO is good (using AES-NI gives almost no difference comparing with 
> unencrypted device), but random IO is poor comparing with unencrypted devices.

Just info for the list - this mail is duplicate of
https://bugzilla.kernel.org/show_bug.cgi?id=17892
so let's use this BZ to track it.

I have some ideas how to improve it, but the change must follow patches which
are currently waiting for upstream inclusion.
(Actually the per-cpu thread patches helps in this case too as side effect.)

Milan
