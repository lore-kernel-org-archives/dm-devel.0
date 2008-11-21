From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] Read the verbosity level from multipath.conf
	configuration file
Date: Fri, 21 Nov 2008 16:58:30 +0900
Message-ID: <49266A26.7040801@ct.jp.nec.com>
References: <1227184875-20831-1-git-send-email-rsarraf@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1227184875-20831-1-git-send-email-rsarraf@netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ritesh Raj Sarraf <rrs@researchut.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Ritesh,

rrs@researchut.com wrote:
> From: Ritesh Raj Sarraf <rrs@researchut.com>
> 
> With this patch, multipathd can read the verbosity level from
> the multipath.conf configuration file.
> For example:
> verbosity       5
snip
> @@ -1316,6 +1327,14 @@ snprint_def_polling_interval (char * buff, int len, void * data)
>  }
>  
>  static int
> +snprint_def_verbosity (char * buff, int len, void * data)
> +{
> +	if (conf->checkint == DEFAULT_VERBOSITY)

Isn't it conf->verbosity?

Thanks,
Kiyoshi Ueda
