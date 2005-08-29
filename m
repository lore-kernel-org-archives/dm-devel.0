From: Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be>
Subject: Re: fibre channel/multipath questions
Date: Mon, 29 Aug 2005 19:35:14 +0200
Message-ID: <200508291935.14243.Rik.Bobbaers@cc.kuleuven.be>
References: <20050829160004.07583734F7@hormel.redhat.com>
	<43133E44.9000904@photoresearchers.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43133E44.9000904@photoresearchers.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Administrator <admin@photoresearchers.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Monday 29 August 2005 18:56, Administrator wrote:
> Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be> wrote:
> > 2. Is it possible to make the fibrechannel driver get loaded AFTER the
> > others?
>
> Yes.  It's in the archives:
>
> http://www.redhat.com/archives/dm-devel/2005-June/msg00142.html

this is the sollution for a modules-enabled kernel. i don't have modules (and 
don't want them, for security reasons... i know, on the fly patching is 
possible, but i've disabled writing to /dev/kmem).

so the question was: is it possible to make the driver get loaded AFTER the 
others in a kernel without modules?

-- 
harry
aka Rik Bobbaers

K.U.Leuven - LUDIT          -=- Tel: +32 485 52 71 50
Rik.Bobbaers@cc.kuleuven.be -=- http://harry.ulyssis.org

Disclaimer:
By sending an email to ANY of my addresses you are agreeing that:
  1. I am by definition, "the intended recipient"
  2. All information in the email is mine to do with as I see fit and make 
such financial profit, political mileage, or good joke as it lends itself to. 
In particular, I may quote it on usenet.
  3. I may take the contents as representing the views of your company.
  4. This overrides any disclaimer or statement of confidentiality that may be 
included on your message. 
