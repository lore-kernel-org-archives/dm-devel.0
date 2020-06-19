From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 21/29] docs: device-mapper: add dm-ebs.rst to
 an index file
Date: Fri, 19 Jun 2020 12:18:14 -0400
Message-ID: <20200619161813.GA24642@redhat.com>
References: <cover.1592203542.git.mchehab+huawei@kernel.org>
	<e6195a56b6e7924ccbb7fd07837453530f02e9dc.1592203542.git.mchehab+huawei@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e6195a56b6e7924ccbb7fd07837453530f02e9dc.1592203542.git.mchehab+huawei@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Linux Doc Mailing List <linux-doc@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Jun 15 2020 at  2:47am -0400,
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Solves this Sphinx warning:
> 	Documentation/admin-guide/device-mapper/dm-ebs.rst: WARNING: document isn't included in any toctree
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/admin-guide/device-mapper/index.rst | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
> index ec62fcc8eece..6cf8adc86fa8 100644
> --- a/Documentation/admin-guide/device-mapper/index.rst
> +++ b/Documentation/admin-guide/device-mapper/index.rst
> @@ -11,6 +11,7 @@ Device Mapper
>      dm-clone
>      dm-crypt
>      dm-dust
> +    dm-ebs
>      dm-flakey
>      dm-init
>      dm-integrity
> -- 
> 2.26.2
> 

Didn't see this fix staged in linux-next so I've picked it up for 5.8.

Thanks,
Mike
