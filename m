From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH] libmultipath/hwtable.c: Compellent Definition
Date: Fri, 11 Jul 2008 12:53:28 -0400
Message-ID: <20080711165328.GB29126@mars.virtualiron.com>
References: <A7519D7FDEF2A144BA6D40BDF13100FEA01806@ex2.Beer.Town>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <A7519D7FDEF2A144BA6D40BDF13100FEA01806@ex2.Beer.Town>
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

On Fri, Jul 11, 2008 at 11:17:03AM -0500, Jim Lester wrote:
> The following is the patch to include a hardware definition for
> Compellent's SAN. This is my first patch so hopefully I did everything
> correctly. The definition in config form is below, if for some reason my
> code doesn't match that, please inform me.
> 
>         device {
>                 vendor "COMPELNT"
>                 product "Compellent Vol"
>                 path_grouping_policy multibus
>                 path_checker tur
>                 checker tur

That is bogus. There are no 'checker' field in the .conf file. Hopefully
that isn't in your product release notes.

>                 failback immediate
>                 no_path_retry queue
>         }
