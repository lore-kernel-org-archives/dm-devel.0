From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH v2 for-3.14] dm cache: add block sizes and
	total cache blocks to status output
Date: Thu, 16 Jan 2014 11:18:37 -0600
Message-ID: <FDEC03AD-6294-403B-8AC9-0A1DF4230E9D@redhat.com>
References: <20140109210412.GA5288@redhat.com>
	<684DDE51-1D4E-44AB-8E85-CDD6F38B5D07@redhat.com>
	<20140109221323.GA5555@redhat.com>
	<20140109235506.GA6154@redhat.com>
	<4DBC7936-62EF-475A-AAFF-B8B6977DD4E8@redhat.com>
	<20140116043456.GA22229@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140116043456.GA22229@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids


On Jan 15, 2014, at 10:34 PM, Mike Snitzer wrote:

> On Wed, Jan 15 2014 at  8:16pm -0500,
> Brassow Jonathan <jbrassow@redhat.com> wrote:
> 
>> I know I'm pushing my luck...
>> 
>> Is it too late to ask for just one more thing?  Would you also consider printing the policy name in the status (INFO)?
>>  <policy_name> <#policy args> <policy args>
>> 
>> This is especially useful when you pass in "default" in the CTR, because you cannot get this value from anywhere... right?
> 
> For the benefit of others, I pushed the change here:
> http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=2f20afc4c3f69030204ce55f24bc68971b500b8a

This doesn't quite produce the info we want.  If I specify "default" in the CTR table, I want the status to show me what the result was (i.e. "mq").  It currently seems to be printing "default" back at me... which isn't helpful.  :)

 brassow
