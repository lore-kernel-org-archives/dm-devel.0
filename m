From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [RFC] dm-crypt: add ability to use keys from the
 kernel key retention service
Date: Wed, 10 Aug 2016 13:16:11 +0200
Message-ID: <7aa99e52-6ad8-9da2-759f-58c47f2e5256@redhat.com>
References: <1470750966-13028-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470750966-13028-1-git-send-email-aryabinin@virtuozzo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrey Ryabinin <aryabinin@virtuozzo.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Igor@redhat.com, Sukhih <igor@virtuozzo.com>, linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On 08/09/2016 03:56 PM, Andrey Ryabinin wrote:

Hi Andrey,

I'm definitely in favour of dm-crypt with support for kernel keyring 
service, but I think this patch do lack in addressing few issues:

Currently the dm-crypt guarantees that on remove ioctl command the 
volume key gets deleted from both crypto layer and device-mapper 
subsystem without exception. I believe we should stick to the guarantee. 
At least let's provide an option that would immediately invalidate the 
key passed via key description on table destruction. Or on last table 
destruction that would reach dm-crypt internal reference count on such 
key equal to zero. Each table key has at least single copy in crypto 
layer anyway... This is no big deal on live system (copy in crypto 
layer) but after proper system shutdown there should be no key in system 
memory (coldboot risk mitigation).

While it may sound contradicting my claim about guaranteed key 
destruction I'd like to be able to perform table load (imagine admin 
wants to resize dm-crypt device) without need of reuploading the key 
every time. Even when such user/admin has no access to already active 
volume key put in a keyring. IOW it doesn't matter what keyring the key 
was originally anchored in. (Re)load of table with valid key description 
should always pass).

The uspace part is about to land in cryptsetup 2.0 hopefully later this 
year. Most probably the kernel keyring will be used with other features 
of 2.0 release apart from loading dm-crypt mappings.

Last but not least: Mind me asking where do you plan to use it? In case 
we come with different implementation I'd like to reassure it'll be 
still of use to you.

Regards Ondrej
