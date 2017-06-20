From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 1/8] libmultipath: load_config: skip
 setting unnecessary defaults
Date: Tue, 20 Jun 2017 11:25:03 -0500
Message-ID: <20170620162503.GH2940@octiron.msp.redhat.com>
References: <20170620114614.26261-1-mwilck@suse.com>
	<20170620114614.26261-2-mwilck@suse.com>
	<4dcb7f57-ec1e-90e9-1f6a-7c8572578d1d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4dcb7f57-ec1e-90e9-1f6a-7c8572578d1d@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Tue, Jun 20, 2017 at 04:36:47PM +0200, Hannes Reinecke wrote:
> On 06/20/2017 01:46 PM, Martin Wilck wrote:
> > We have the logic for setting defaults for paths and maps
> > in propsel.c. By pre-setting conf values with defaults in
> > load_config(), we generate irritating log messages like
> > 'features =3D "0" (setting: multipath.conf defaults/devices section)'
> > if multipath.conf doesn't contain a features setting at all.
> > =

> > For some config settings, we need to use declare_def_snprint_defint()
> > now to make sure "multipathd show config" prints all defaults correctly.
> > To avoid confusion, we don't do this for "max_sectors", because
> > multipathd leaves this untouched by default.
> > =

> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  libmultipath/config.c  | 16 ----------------
> >  libmultipath/dict.c    | 11 +++++++----
> >  libmultipath/propsel.c |  5 +++++
> >  3 files changed, 12 insertions(+), 20 deletions(-)
> > =

> > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > index bb6619b3..61bbba91 100644
> > --- a/libmultipath/config.c
> > +++ b/libmultipath/config.c
> > @@ -599,40 +599,24 @@ load_config (char * file)
> >  	if (!conf->verbosity)
> >  		conf->verbosity =3D DEFAULT_VERBOSITY;
> >  =

> > -	conf->minio =3D DEFAULT_MINIO;
> > -	conf->minio_rq =3D DEFAULT_MINIO_RQ;
> >  	get_sys_max_fds(&conf->max_fds);
> >  	conf->bindings_file =3D set_default(DEFAULT_BINDINGS_FILE);
> >  	conf->wwids_file =3D set_default(DEFAULT_WWIDS_FILE);
> >  	conf->multipath_dir =3D set_default(DEFAULT_MULTIPATHDIR);
> > -	conf->features =3D set_default(DEFAULT_FEATURES);
> > -	conf->flush_on_last_del =3D DEFAULT_FLUSH;
> >  	conf->attribute_flags =3D 0;
> >  	conf->reassign_maps =3D DEFAULT_REASSIGN_MAPS;
> >  	conf->checkint =3D DEFAULT_CHECKINT;
> >  	conf->max_checkint =3D 0;
> > -	conf->pgfailback =3D DEFAULT_FAILBACK;
> > -	conf->fast_io_fail =3D DEFAULT_FAST_IO_FAIL;
> > -	conf->retain_hwhandler =3D DEFAULT_RETAIN_HWHANDLER;
> > -	conf->detect_prio =3D DEFAULT_DETECT_PRIO;
> > -	conf->detect_checker =3D DEFAULT_DETECT_CHECKER;
> >  	conf->force_sync =3D DEFAULT_FORCE_SYNC;
> >  	conf->partition_delim =3D DEFAULT_PARTITION_DELIM;
> >  	conf->processed_main_config =3D 0;
> >  	conf->find_multipaths =3D DEFAULT_FIND_MULTIPATHS;
> >  	conf->uxsock_timeout =3D DEFAULT_REPLY_TIMEOUT;
> > -	conf->uid_attribute =3D set_default(DEFAULT_UID_ATTRIBUTE);
> >  	conf->retrigger_tries =3D DEFAULT_RETRIGGER_TRIES;
> >  	conf->retrigger_delay =3D DEFAULT_RETRIGGER_DELAY;
> >  	conf->uev_wait_timeout =3D DEFAULT_UEV_WAIT_TIMEOUT;
> > -	conf->deferred_remove =3D DEFAULT_DEFERRED_REMOVE;
> > -	conf->skip_kpartx =3D DEFAULT_SKIP_KPARTX;
> >  	conf->disable_changed_wwids =3D DEFAULT_DISABLE_CHANGED_WWIDS;
> >  	conf->remove_retries =3D 0;
> > -	conf->max_sectors_kb =3D DEFAULT_MAX_SECTORS_KB;
> > -	conf->san_path_err_threshold =3D DEFAULT_ERR_CHECKS;
> > -	conf->san_path_err_forget_rate =3D DEFAULT_ERR_CHECKS;
> > -	conf->san_path_err_recovery_time =3D DEFAULT_ERR_CHECKS;
> >  =

> >  	/*
> >  	 * preload default hwtable
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index 82066f67..9dc10904 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -630,7 +630,7 @@ print_fast_io_fail(char * buff, int len, void *ptr)
> >  }
> >  =

> >  declare_def_handler(fast_io_fail, set_fast_io_fail)
> > -declare_def_snprint(fast_io_fail, print_fast_io_fail)
> > +declare_def_snprint_defint(fast_io_fail, print_fast_io_fail, DEFAULT_F=
AST_IO_FAIL)
> >  declare_ovr_handler(fast_io_fail, set_fast_io_fail)
> >  declare_ovr_snprint(fast_io_fail, print_fast_io_fail)
> >  declare_hw_handler(fast_io_fail, set_fast_io_fail)
> > @@ -1082,7 +1082,8 @@ declare_hw_snprint(delay_wait_checks, print_off_i=
nt_undef)
> >  declare_mp_handler(delay_wait_checks, set_off_int_undef)
> >  declare_mp_snprint(delay_wait_checks, print_off_int_undef)
> >  declare_def_handler(san_path_err_threshold, set_off_int_undef)
> > -declare_def_snprint(san_path_err_threshold, print_off_int_undef)
> > +declare_def_snprint_defint(san_path_err_threshold, print_off_int_undef,
> > +			   DEFAULT_ERR_CHECKS)
> >  declare_ovr_handler(san_path_err_threshold, set_off_int_undef)
> >  declare_ovr_snprint(san_path_err_threshold, print_off_int_undef)
> >  declare_hw_handler(san_path_err_threshold, set_off_int_undef)
> > @@ -1090,7 +1091,8 @@ declare_hw_snprint(san_path_err_threshold, print_=
off_int_undef)
> >  declare_mp_handler(san_path_err_threshold, set_off_int_undef)
> >  declare_mp_snprint(san_path_err_threshold, print_off_int_undef)
> >  declare_def_handler(san_path_err_forget_rate, set_off_int_undef)
> > -declare_def_snprint(san_path_err_forget_rate, print_off_int_undef)
> > +declare_def_snprint_defint(san_path_err_forget_rate, print_off_int_und=
ef,
> > +			   DEFAULT_ERR_CHECKS)
> >  declare_ovr_handler(san_path_err_forget_rate, set_off_int_undef)
> >  declare_ovr_snprint(san_path_err_forget_rate, print_off_int_undef)
> >  declare_hw_handler(san_path_err_forget_rate, set_off_int_undef)
> > @@ -1098,7 +1100,8 @@ declare_hw_snprint(san_path_err_forget_rate, prin=
t_off_int_undef)
> >  declare_mp_handler(san_path_err_forget_rate, set_off_int_undef)
> >  declare_mp_snprint(san_path_err_forget_rate, print_off_int_undef)
> >  declare_def_handler(san_path_err_recovery_time, set_off_int_undef)
> > -declare_def_snprint(san_path_err_recovery_time, print_off_int_undef)
> > +declare_def_snprint_defint(san_path_err_recovery_time, print_off_int_u=
ndef,
> > +			   DEFAULT_ERR_CHECKS)
> >  declare_ovr_handler(san_path_err_recovery_time, set_off_int_undef)
> >  declare_ovr_snprint(san_path_err_recovery_time, print_off_int_undef)
> >  declare_hw_handler(san_path_err_recovery_time, set_off_int_undef)
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index 385063aa..68436433 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -752,6 +752,11 @@ int select_max_sectors_kb(struct config *conf, str=
uct multipath * mp)
> >  	mp_set_ovr(max_sectors_kb);
> >  	mp_set_hwe(max_sectors_kb);
> >  	mp_set_conf(max_sectors_kb);
> > +	mp_set_default(max_sectors_kb, DEFAULT_MAX_SECTORS_KB);
> > +	/*
> > +	 * In the default case, we will not modify max_sectors_kb.
> > +	 * Don't print a log message to avoid user confusion.
> > +	 */
> >  	return 0;
> >  out:
> >  	condlog(3, "%s: max_sectors_kb =3D %i %s", mp->alias, mp->max_sectors=
_kb,
> > =

> Errm. You just set the default value, no?
> Care to clarify this comment?

The default value is "undefined". This isn't strictly necessary if all
the other code is correct, but in case mpp->max_sectors_kb was
previously set to something (or never zeroed out initially), this will
correctly set it back to undefined.

-Ben

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
