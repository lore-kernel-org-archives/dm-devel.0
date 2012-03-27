From: Milan Broz <mbroz@redhat.com>
Subject: Re: CPU hotplug issue in dm-crypt driver
Date: Tue, 27 Mar 2012 14:51:32 +0200
Message-ID: <4F71B7D4.8030209@redhat.com>
References: <547dd161c75a98c7bcf4fb7a4d54b914.squirrel@www.codeaurora.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <547dd161c75a98c7bcf4fb7a4d54b914.squirrel@www.codeaurora.org>
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
Cc: mittals@codeaurora.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 03/26/2012 09:28 PM, mittals@codeaurora.org wrote:
> 1) Is it a know problem that there is some issue with dm-crypt driver with
> cpu hotplug?

It is quite possible that there is a bug on CPU hotplugging.

Can you please sent your patch/workaround and how you can reproduce it?

(The code in dmcrypt will change in future. Anyway Mikulas already
had some complaints here regarding CPU hotplug, adding him to cc.)

Milan
