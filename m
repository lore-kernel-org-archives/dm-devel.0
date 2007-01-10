From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] add the ability to have blacklist exceptions
	for specific vendor:product
Date: Wed, 10 Jan 2007 23:08:55 +0100
Message-ID: <1168466935.16162.16.camel@localhost.localdomain>
References: <20070110001725.GB13146@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070110001725.GB13146@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On mar, 2007-01-09 at 18:17 -0600, Benjamin Marzinski wrote:
> This patch adds the ability to have blacklist exceptions for vendor:product
> devices.  Also, the wwid and devnode exceptions weren't getting freed properly
> in free_config, so that is fixed as well.
> 
Thanks for the prompt review, and enhancement.
Applied.
