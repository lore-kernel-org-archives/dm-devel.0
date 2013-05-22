From: Milan Broz <gmazyland@gmail.com>
Subject: Re: DM-Verity Tool
Date: Wed, 22 May 2013 18:46:36 +0200
Message-ID: <519CF66C.8010808@gmail.com>
References: <22416.192.168.200.1.1369149109.squirrel@gesmail.globaledgesoft.com>
	<519CA6F0.3000309@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <519CA6F0.3000309@redhat.com>
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
Cc: pavankumar.p@globaledgesoft.com, Marian Csontos <mcsontos@redhat.com>
List-Id: dm-devel.ids

On 05/22/2013 01:07 PM, Marian Csontos wrote:
> On 05/21/2013 05:11 PM, pavankumar.p@globaledgesoft.com wrote:
>> Hello Mandeep,
>>
>> I was trying to download the source code to generate the hash from the
>> following location. But looks like this is moved. Pls share the latest git
>> hub location of the source.
>> http://git.chromium.org/cgi-bin/gitweb.cgi?p=dm-verity.git;a=tree
> 
> Hi Pavan, dm-verity is in upstream kernel tree now:
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/md/dm-verity.c

I think the question was about tool to generate hash,
not the target itself.

In any case, dm-verity is in kernel and veritysetup tool is part of upstream
cryptsetup package.

Documentation to kernel dm-verity
http://code.google.com/p/cryptsetup/wiki/DMVerity

And some release notes info about veritysetup (see man page as well)
http://code.google.com/p/cryptsetup/wiki/Cryptsetup150

Milan
