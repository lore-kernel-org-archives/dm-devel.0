From: Milan Broz <mbroz@redhat.com>
Subject: Re: Barrier support in device mapper
Date: Thu, 18 Sep 2008 20:34:49 +0200
Message-ID: <48D29F49.1050003@redhat.com>
References: <200809181127.37704.knikanth@suse.de> <48D1FBBE.4080305@redhat.com>
	<20080918134412.GK25711@one.firstfloor.org>
	<48D27D17.6040207@redhat.com>
	<20080918181311.GN25711@one.firstfloor.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080918181311.GN25711@one.firstfloor.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andi Kleen <andi@firstfloor.org>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Andi Kleen wrote:
>> The mail I replied to contains links to all mentioned patches:
>>
>>> [1] http://lkml.org/lkml/2008/2/15/125
>>> [2] http://article.gmane.org/gmane.linux.kernel.device-mapper.devel/5941
> 
> That's just a description, where are the patches?

http://article.gmane.org/gmane.linux.kernel.device-mapper.devel/5942
http://article.gmane.org/gmane.linux.kernel.device-mapper.devel/5943
http://article.gmane.org/gmane.linux.kernel.device-mapper.devel/5944
http://article.gmane.org/gmane.linux.kernel.device-mapper.devel/5945

> Are they equivalent in the single disk case to my patch?
It transforms barrier to normal bio with following zero-size barrier bio.
For the one disk case effect is the same of course.

Milan
