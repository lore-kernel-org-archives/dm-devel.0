From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] Don't add 'p' delimiter when you shouldn't
Date: Thu, 09 Feb 2012 21:17:27 +0100
Message-ID: <1328818647.17706.1.camel@lapoo.opensvc.com>
References: <4F0A5A27.8090107@ubuntu.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F0A5A27.8090107@ubuntu.com>
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

On dim., 2012-01-08 at 22:08 -0500, Phillip Susi wrote:
> The 'p' delimiter is supposed to be added when the base disk name
> ends in a digit.  This decision was based on the name given on the
> command line, not the canonical device name, so giving /dev/dm-0
> instead of /dev/mapper/foo triggered the digit test and added the
> 'p'.  Changed test to use the canonical name rather than the given
> name. 

Rebased and merged.

Thanks.
