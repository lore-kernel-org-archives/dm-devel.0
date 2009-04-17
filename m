From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [RFC] dm snapshot based asynchronous replication
Date: Fri, 17 Apr 2009 13:01:39 -0500
Message-ID: <540AD48B-A810-4F15-BEA0-5879350EA893@redhat.com>
References: <137413921.2150341239820262767.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<1046537454.2150461239820304817.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<20090416070213.GA7566@johann>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090416070213.GA7566@johann>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


On Apr 16, 2009, at 2:02 AM, Lars Ellenberg wrote:

> On Wed, Apr 15, 2009 at 08:31:44PM +0200, christophe.varoqui@free.fr  
> wrote:
>>> Should I understand there's no way for userspace to extract from  
>>> the device mapper the cow'ed chunk list of a vanilla snapshot ?
>>
>> Replying to myself, I found an instructive post from Lars of the  
>> drdb folks : http://markmail.org/message/7qdbp36tohasojuy (thanks  
>> for sharing Lars)
>>
>> This script is easy enough to morph from its original snapshot  
>> reverting purpose to the replication model using the cow device as  
>> a changelog I described.
>>
>> Thanks for the inputs. I'll keep posting if I something of general  
>> interest comes out of this stuff.
>
> that perl hack was meanwhile ported to C by someone.
> posted earlier this year on dm-devel.
> also please do not ignore the Zumastor work.

It also seems that the script is not generic enough to handle the  
variety of exception stores that are coming.  I just wrote a 'snapshot- 
merge' target that will do what you ask.  I will post the patch  
shortly.  However, this won't help you in RHEL5.

  brassow
