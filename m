From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 01/10] dm snapshot: Use kmalloc_array() in
 init_origin_hash()
Date: Thu, 29 Sep 2016 11:54:24 +0200
Message-ID: <1475142864.31297.5.camel@tiscali.nl>
References: <566ABCD9.1060404@users.sourceforge.net>
         <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
         <3861d349-48fd-162b-a749-83e007f70b41@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3861d349-48fd-162b-a749-83e007f70b41@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

Andy, Joe,

On Thu, 2016-09-29 at 11:07 +0200, SF Markus Elfring wrote:
> * Multiplications for the size determination of memory allocations
>   indicated that array data structures should be processed.
>   Thus use the corresponding function "kmalloc_array".
> 
>   This issue was detected by using the Coccinelle software.

We have no hope of fixing Markus' homegrown coccinelle script. But we
could try to fix the checkpatch false positive here. Something like:

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 206a6b3..b47201d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5693,7 +5693,7 @@ sub process {
 				$r2 = $a1;
 			}
 			if ($r1 !~ /^sizeof\b/ && $r2 =~ /^sizeof\s*\S/ &&
-			    !($r1 =~ /^$Constant$/ || $r1 =~ /^[A-Z_][A-Z0-9_]*$/)) {
+			    !($r1 =~ /^$Constant$/ || $r1 =~ /^[A-Z_][A-Z0-9_]*\b/)) {
 				if (WARN("ALLOC_WITH_MULTIPLY",
 					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
 				    $fix) {

Does that work for you too?

> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -326,8 +326,9 @@ static int init_origin_hash(void)
>  {
>  	int i;
>  
> -	_origins = kmalloc(ORIGIN_HASH_SIZE * sizeof(struct list_head),
> -			   GFP_KERNEL);
> +	_origins = kmalloc_array(ORIGIN_HASH_SIZE,
> +				 sizeof(*_origins),
> +				 GFP_KERNEL);
>  	if (!_origins) {
>  		DMERR("unable to allocate memory for _origins");
>  		return -ENOMEM;
> @@ -335,8 +336,9 @@ static int init_origin_hash(void)
>  	for (i = 0; i < ORIGIN_HASH_SIZE; i++)
>  		INIT_LIST_HEAD(_origins + i);
>  
> -	_dm_origins = kmalloc(ORIGIN_HASH_SIZE * sizeof(struct list_head),
> -			      GFP_KERNEL);
> +	_dm_origins = kmalloc_array(ORIGIN_HASH_SIZE,
> +				    sizeof(*_dm_origins),
> +				    GFP_KERNEL);
>  	if (!_dm_origins) {
>  		DMERR("unable to allocate memory for _dm_origins");
>  		kfree(_origins);

Thanks,


Paul Bolle
