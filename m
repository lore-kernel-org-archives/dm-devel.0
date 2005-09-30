From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFT/RFC 4/4] add dm-hp-sw hw handler
Date: Fri, 30 Sep 2005 15:57:57 -0500
Message-ID: <433DA6D5.2040901@cs.wisc.edu>
References: <1128109342.24395.26.camel@max> <433DA3AB.9010900@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <433DA3AB.9010900@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rkenna@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Rob Kenna wrote:
> Hey Mike -
> 
> Is this for HP active/passive support?  Thanks.
> 

Right now, it is for active/passive when you require 
manual/explicit/some-magic-command/whatever-vendorX-calls-it 
failover/logical-unit-access. HP or Christophe can give details about 
the specific models.

I was not sure if these boxes do active/passive 
automaitc/implicit/whatever too. If so I guess we need some config code 
in the create function so I do not send the start stop for the automatic 
failover case. I have not gotton to look at the qlogic code, becuase I 
have been busy rediffing and testing other patches so I only know what I 
remember Christophe telling me :)
