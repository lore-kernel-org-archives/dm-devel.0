From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH]multipath-tools: cleanup for all
 unused-but-set-variable variables in mpathpersist
Date: Wed, 07 Mar 2012 22:32:25 +0100
Message-ID: <1331155945.19673.24.camel@lapoo.opensvc.com>
References: <F200AD42A082BC4088B232D13A916A8901C8DE@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F200AD42A082BC4088B232D13A916A8901C8DE@SACEXCMBX02-PRD.hq.netapp.com>
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

On mar., 2012-03-06 at 15:11 +0000, Chauhan, Vijay wrote:
> This patch is a cleanup for all unused-but-set-variable variables 
> in mpathpersist.
> 
Applied.

> Signed-off-by: Vijay Chauhan <vijay.chauhan@netapp.com>
> 
> ---
> diff -uprN multipath-tools.orig/libmpathpersist/mpath_persist.c multipath-tools/libmpathpersist/mpath_persist.c
> --- multipath-tools.orig/libmpathpersist/mpath_persist.c	2012-03-04 02:16:55.000000000 -0500
> +++ multipath-tools/libmpathpersist/mpath_persist.c	2012-03-04 02:52:24.000000000 -0500
> @@ -394,14 +394,8 @@ void * mpath_prin_pthread_fn (void *p)
>  int mpath_send_prin_activepath (char * dev, int rq_servact, struct prin_resp * resp, int noisy)
>  {
>  
> -	struct prin_param param;
>  	int rc;
>  
> -	param.rq_servact = rq_servact; 
> -	param.resp = resp;
> -	param.noisy = noisy;
> -	param.status = MPATH_PR_OTHER;
> -
>  	rc = prin_do_scsi_ioctl(dev, rq_servact, resp,  noisy);
>  	
>  	return (rc);
> @@ -550,7 +544,6 @@ int mpath_prout_common(struct multipath 
>  	int i,j, ret;
>  	struct pathgroup *pgp = NULL;
>  	struct path *pp = NULL;
> -	struct path *pptemp = NULL;
>  
>  	vector_foreach_slot (mpp->pg, pgp, j){
>  		vector_foreach_slot (pgp->paths, pp, i){
> @@ -562,7 +555,6 @@ int mpath_prout_common(struct multipath 
>  			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
>  			ret = send_prout_activepath(pp->dev, rq_servact, rq_scope, rq_type, 
>  					paramp, noisy); 
> -			pptemp = pp;
>  			return ret ;
>  		}
>  	}
> diff -uprN multipath-tools.orig/libmpathpersist/mpath_pr_ioctl.c multipath-tools/libmpathpersist/mpath_pr_ioctl.c
> --- multipath-tools.orig/libmpathpersist/mpath_pr_ioctl.c	2012-03-04 02:16:55.000000000 -0500
> +++ multipath-tools/libmpathpersist/mpath_pr_ioctl.c	2012-03-04 02:36:43.000000000 -0500
> @@ -516,7 +516,6 @@ void
>  dumpHex(const char* str, int len, int log)
>  {
>  	const char * p = str;
> -	const char * formatstr;
>  	unsigned char c;
>  	char buff[82];
>  	const int bpstart = 5;
> @@ -525,7 +524,6 @@ dumpHex(const char* str, int len, int lo
>  
>  	if (len <= 0)
>  		return;
> -	formatstr = (0 == log) ? "%.76s\n" : "%.56s\n";
>  	memset(buff, ' ', 80);
>  	buff[80] = '\0';
>  	for (k = 0; k < len; k++) {
> diff -uprN multipath-tools.orig/mpathpersist/main.c multipath-tools/mpathpersist/main.c
> --- multipath-tools.orig/mpathpersist/main.c	2012-03-04 02:16:55.000000000 -0500
> +++ multipath-tools/mpathpersist/main.c	2012-03-04 02:56:37.000000000 -0500
> @@ -400,9 +400,7 @@ int main (int argc, char * argv[])
>  	else if (prout)
>  	{
>  		int j; 
> -		int t_arr_len=0;
>  		struct prout_param_descriptor *paramp;
> -		t_arr_len = MPATH_MX_TID_LEN * num_transport;
>  
>  		paramp= malloc(sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS )));
>  		
> --
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
