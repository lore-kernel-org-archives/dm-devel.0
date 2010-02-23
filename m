From: Luca Berra <bluca@comedia.it>
Subject: Re: [dmraid 1/3] Remove incorrect quoting from
	pattern	in lib/Makefile.in
Date: Tue, 23 Feb 2010 07:44:21 +0100
Message-ID: <20100223064421.GA22004@maude.comedia.it>
References: <20100202072544.305994749@suse.de>
	<20100202072751.083034080@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100202072751.083034080@suse.de>
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

On Tue, Feb 02, 2010 at 06:25:45PM +1100, neilb@suse.de wrote:
>The 
>   [[ string =~ pattern ]]
>command in bash only treats unquoted characters in 'pattern'
>as being pattern characters.  If they are quoted, they much match
>literally.
>

why all this bashism?

>-		if [[ "$$n" =~ '.so$$' ]]; then \

posix would make it 
         if [ -z "$${n##*.so}" ] ; then \

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
