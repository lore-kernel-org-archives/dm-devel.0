From: Joe Thornber <thornber@redhat.com>
Subject: Re: [RFC] dm-writeboost: Porting daemon modulating
 migration from userland into the kernel
Date: Mon, 16 Sep 2013 10:21:35 +0100
Message-ID: <20130916092134.GA20647@debian>
References: <5236C737.7040306@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5236C737.7040306@gmail.com>
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
Cc: gregkh@linuxfoundation.org
List-Id: dm-devel.ids

On Mon, Sep 16, 2013 at 05:54:15PM +0900, Akira Hayakawa wrote:
> Hi, DM Guys,
> 
> I am thinking of a little design change
> as to autonomous migration feature.
> I want to share this issue with you
> to first ask for your advice
> and for you to deeply understand the 
> functionality of dm-writeboost at the same time.

I'm a bit confused.  On the one hand you've asked for this to be
included in linux-next, yet on the other you're still making big
design changes.

When you first posted this code I said you'd need to get some people
behind it who are using this successfully.  How far along this path
are you?

- Joe
