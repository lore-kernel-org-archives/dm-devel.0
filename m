From: Jim Minter <jminter@redhat.com>
Subject: Re: potential dm-thin recovery issue
Date: Wed, 06 Mar 2013 16:13:14 +0000
Message-ID: <51376B1A.2090201@redhat.com>
References: <1196562.58.1362575588488.JavaMail.javamailuser@localhost>
	<15744185.65.1362576412628.JavaMail.javamailuser@localhost>
	<20130306142706.GB4852@raspberrypi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130306142706.GB4852@raspberrypi>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 03/06/13 14:27, thornber@redhat.com wrote:
> On Wed, Mar 06, 2013 at 08:26:55AM -0500, Jim Minter wrote:
>> Hello,
>>
>> Following on from my previous e-mail ("dm-thin discard issue"), I'm having trouble recovering from the metadata corruption state I got into.  I'm using the latest userland tools cloned from https://github.com/jthornber/thin-provisioning-tools .  Here's what I've tried; am I going wrong somewhere, or is there potentially an issue with the tools?
>
> Are you using the v1.5 tag? or just taking my latest dev?
>
> - Joe
>

I don't see a v1.5 tag -- I cloned straight from master.

Cheers,

Jim
