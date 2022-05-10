Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F53AC43217
	for <dm-devel@archiver.kernel.org>; Wed, 11 May 2022 08:11:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-Md2aK1t0PyyTPNQcXL5GDA-1; Wed, 11 May 2022 04:11:29 -0400
X-MC-Unique: Md2aK1t0PyyTPNQcXL5GDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F1D4811E80;
	Wed, 11 May 2022 08:11:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0BC4B40D2820;
	Wed, 11 May 2022 08:11:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 29C181932203;
	Wed, 11 May 2022 08:11:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ACC361947055
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 May 2022 10:32:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8ABC6111E407; Tue, 10 May 2022 10:32:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 86349111E3FB
 for <dm-devel@redhat.com>; Tue, 10 May 2022 10:32:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3978F3C1618D
 for <dm-devel@redhat.com>; Tue, 10 May 2022 10:32:03 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-uTy8QPurMp62WBPPZSTUTg-1; Tue, 10 May 2022 06:32:01 -0400
X-MC-Unique: uTy8QPurMp62WBPPZSTUTg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 2D25D21B87;
 Tue, 10 May 2022 10:32:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0EF5E13AC1;
 Tue, 10 May 2022 10:32:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id NJWcAiA/emKoTwAAMHmgww
 (envelope-from <mliska@suse.cz>); Tue, 10 May 2022 10:32:00 +0000
Message-ID: <2f5826b9-180b-f926-97ce-77dcebf062d0@suse.cz>
Date: Tue, 10 May 2022 12:31:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: mwilck@suse.com, Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20220510093538.25199-1-mwilck@suse.com>
 <20220510093538.25199-2-mwilck@suse.com>
From: =?UTF-8?Q?Martin_Li=c5=a1ka?= <mliska@suse.cz>
In-Reply-To: <20220510093538.25199-2-mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Wed, 11 May 2022 08:11:20 +0000
Subject: Re: [dm-devel] [PATCH 2/2] multipath-tools: cleanly separate
 CPPFLAGS and CFLAGS
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/10/22 11:35, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Move all preprocessor-related options (-D, -I) into CPPFLAGS. This is
> cleaner, and has the side effect of creating a better-readable output from
> "make".
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Martin Liska <mliska@suse.cz>

> ---
>  Makefile.inc                       |  4 ++--
>  kpartx/Makefile                    |  5 +++--
>  libdmmp/Makefile                   |  4 ++--
>  libdmmp/test/Makefile              |  2 +-
>  libmpathvalid/Makefile             |  3 ++-
>  libmultipath/Makefile              | 19 ++++++++++---------
>  libmultipath/checkers/Makefile     |  3 ++-
>  libmultipath/foreign/Makefile      |  3 ++-
>  libmultipath/prioritizers/Makefile |  5 +++--
>  mpathpersist/Makefile              |  3 ++-
>  multipath/Makefile                 |  3 ++-
>  multipathd/Makefile                | 23 ++++++++++++-----------
>  tests/Makefile                     |  4 ++--
>  13 files changed, 45 insertions(+), 36 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index 7422666..bcd2212 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -140,10 +140,10 @@ OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
>  WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
>  		  -Werror=implicit-function-declaration -Werror=format-security \
>  		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS)
> -CPPFLAGS	:= $(FORTIFY_OPT)
> -CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
> +CPPFLAGS	:= $(FORTIFY_OPT) \
>  		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" -DRUN_DIR=\"${RUN}\" \
>  		   -DCONFIG_DIR=\"$(configdir)\" -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
> +CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe
>  BIN_CFLAGS	= -fPIE -DPIE
>  LIB_CFLAGS	= -fPIC
>  SHARED_FLAGS	= -shared
> diff --git a/kpartx/Makefile b/kpartx/Makefile
> index e9900fb..742d3bc 100644
> --- a/kpartx/Makefile
> +++ b/kpartx/Makefile
> @@ -3,13 +3,14 @@
>  #
>  include ../Makefile.inc
>  
> -CFLAGS += $(BIN_CFLAGS) -I. -I$(multipathdir) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
> +CPPFLAGS += -I. -I$(multipathdir) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
> +CFLAGS += $(BIN_CFLAGS)
>  LDFLAGS += $(BIN_LDFLAGS)
>  
>  LIBDEPS += -ldevmapper
>  
>  ifneq ($(call check_func,dm_task_set_cookie,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
> -	CFLAGS += -DLIBDM_API_COOKIE
> +	CPPFLAGS += -DLIBDM_API_COOKIE
>  endif
>  
>  OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o sun.o \
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index 00fc852..2e99b3e 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -15,8 +15,8 @@ HEADERS = libdmmp/libdmmp.h
>  
>  OBJS = libdmmp.o libdmmp_mp.o libdmmp_pg.o libdmmp_path.o libdmmp_misc.o
>  
> -CFLAGS += $(LIB_CFLAGS) -fvisibility=hidden -I$(libdmmpdir) -I$(mpathcmddir) \
> -	  $(shell $(PKGCONFIG) --cflags json-c)
> +CPPFLAGS += -I$(libdmmpdir) -I$(mpathcmddir) $(shell $(PKGCONFIG) --cflags json-c)
> +CFLAGS += $(LIB_CFLAGS) -fvisibility=hidden
>  
>  LIBDEPS += $(shell $(PKGCONFIG) --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthread
>  
> diff --git a/libdmmp/test/Makefile b/libdmmp/test/Makefile
> index 20b3945..76b24d6 100644
> --- a/libdmmp/test/Makefile
> +++ b/libdmmp/test/Makefile
> @@ -9,7 +9,7 @@ _mpathcmddir=../$(mpathcmddir)
>  
>  TEST_EXEC = libdmmp_test
>  SPD_TEST_EXEC = libdmmp_speed_test
> -CFLAGS += -I$(_libdmmpdir)
> +CPPFLAGS += -I$(_libdmmpdir)
>  LDFLAGS += -L$(_libdmmpdir) -ldmmp
>  
>  all: $(TEST_EXEC) $(SPD_TEST_EXEC)
> diff --git a/libmpathvalid/Makefile b/libmpathvalid/Makefile
> index fefeb2a..0a51925 100644
> --- a/libmpathvalid/Makefile
> +++ b/libmpathvalid/Makefile
> @@ -5,7 +5,8 @@ DEVLIB = libmpathvalid.so
>  LIBS = $(DEVLIB).$(SONAME)
>  VERSION_SCRIPT := libmpathvalid.version
>  
> -CFLAGS += $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
> +CPPFLAGS += -I$(multipathdir) -I$(mpathcmddir)
> +CFLAGS += $(LIB_CFLAGS)
>  
>  LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) \
>  	   -lmultipath -L$(mpathcmddir) -lmpathcmd -ludev
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 2fc3f3b..fb03200 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -8,12 +8,13 @@ DEVLIB = libmultipath.so
>  LIBS = $(DEVLIB).$(SONAME)
>  VERSION_SCRIPT := libmultipath.version
>  
> -CFLAGS += $(LIB_CFLAGS) -I$(mpathcmddir) -I$(mpathpersistdir) -I$(nvmedir)
> +CPPFLAGS += -I$(mpathcmddir) -I$(mpathpersistdir) -I$(nvmedir)
> +CFLAGS += $(LIB_CFLAGS)
>  
>  LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd -lurcu -laio
>  
>  ifdef SYSTEMD
> -	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
> +	CPPFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
>  	ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
>  		LIBDEPS += -lsystemd
>  	else
> @@ -22,31 +23,31 @@ ifdef SYSTEMD
>  endif
>  
>  ifneq ($(call check_func,dm_task_no_flush,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
> -	CFLAGS += -DLIBDM_API_FLUSH -D_GNU_SOURCE
> +	CPPFLAGS += -DLIBDM_API_FLUSH -D_GNU_SOURCE
>  endif
>  
>  ifneq ($(call check_func,dm_task_get_errno,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
> -	CFLAGS += -DLIBDM_API_GET_ERRNO
> +	CPPFLAGS += -DLIBDM_API_GET_ERRNO
>  endif
>  
>  ifneq ($(call check_func,dm_task_set_cookie,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
> -	CFLAGS += -DLIBDM_API_COOKIE
> +	CPPFLAGS += -DLIBDM_API_COOKIE
>  endif
>  
>  ifneq ($(call check_func,udev_monitor_set_receive_buffer_size,$(LIBUDEV_INCDIR)/libudev.h),0)
> -	CFLAGS += -DLIBUDEV_API_RECVBUF
> +	CPPFLAGS += -DLIBUDEV_API_RECVBUF
>  endif
>  
>  ifneq ($(call check_func,dm_task_deferred_remove,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
> -	CFLAGS += -DLIBDM_API_DEFERRED
> +	CPPFLAGS += -DLIBDM_API_DEFERRED
>  endif
>  
>  ifneq ($(call check_func,dm_hold_control_dev,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
> -	CFLAGS += -DLIBDM_API_HOLD_CONTROL
> +	CPPFLAGS += -DLIBDM_API_HOLD_CONTROL
>  endif
>  
>  ifneq ($(call check_var,ELS_DTAG_LNK_INTEGRITY,$(LINUX_HEADERS_INCDIR)/scsi/fc/fc_els.h),0)
> -	CFLAGS += -DFPIN_EVENT_HANDLER
> +	CPPFLAGS += -DFPIN_EVENT_HANDLER
>  endif
>  
>  # object files referencing MULTIPATH_DIR or CONFIG_DIR
> diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
> index 8e0ed5e..8d8e45e 100644
> --- a/libmultipath/checkers/Makefile
> +++ b/libmultipath/checkers/Makefile
> @@ -3,7 +3,8 @@
>  #
>  include ../../Makefile.inc
>  
> -CFLAGS += $(LIB_CFLAGS) -I..
> +CPPFLAGS += -I..
> +CFLAGS += $(LIB_CFLAGS)
>  LDFLAGS += -L.. -lmultipath
>  LIBDEPS = -lmultipath -laio -lpthread -lrt
>  
> diff --git a/libmultipath/foreign/Makefile b/libmultipath/foreign/Makefile
> index f447a1c..42cea4d 100644
> --- a/libmultipath/foreign/Makefile
> +++ b/libmultipath/foreign/Makefile
> @@ -4,7 +4,8 @@
>  TOPDIR=../..
>  include ../../Makefile.inc
>  
> -CFLAGS += $(LIB_CFLAGS) -I.. -I$(nvmedir)
> +CPPFLAGS += -I.. -I$(nvmedir)
> +CFLAGS += $(LIB_CFLAGS)
>  LDFLAGS += -L..
>  LIBDEPS = -lmultipath -ludev -lpthread -lrt
>  
> diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
> index 16c6397..a5ab5e1 100644
> --- a/libmultipath/prioritizers/Makefile
> +++ b/libmultipath/prioritizers/Makefile
> @@ -3,7 +3,8 @@
>  #
>  include ../../Makefile.inc
>  
> -CFLAGS += $(LIB_CFLAGS) -I..
> +CPPFLAGS += -I..
> +CFLAGS += $(LIB_CFLAGS)
>  LDFLAGS += -L..
>  LIBDEPS = -lmultipath -lm -lpthread -lrt
>  
> @@ -25,7 +26,7 @@ LIBS = \
>  
>  ifneq ($(call check_file,$(LINUX_HEADERS_INCDIR)/linux/nvme_ioctl.h),0)
>  	LIBS += libprioana.so
> -	CFLAGS += -I../nvme
> +	CPPFLAGS += -I../nvme
>  endif
>  
>  all: $(LIBS)
> diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
> index eb26970..2e4d483 100644
> --- a/mpathpersist/Makefile
> +++ b/mpathpersist/Makefile
> @@ -1,6 +1,7 @@
>  include ../Makefile.inc
>  
> -CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir)
> +CPPFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
> +CFLAGS += $(BIN_CFLAGS)
>  LDFLAGS += $(BIN_LDFLAGS)
>  
>  LIBDEPS += -L$(mpathpersistdir) -lmpathpersist -L$(multipathdir) -lmultipath \
> diff --git a/multipath/Makefile b/multipath/Makefile
> index c930499..bcb0453 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -3,7 +3,8 @@
>  #
>  include ../Makefile.inc
>  
> -CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
> +CPPFLAGS += -I$(multipathdir) -I$(mpathcmddir)
> +CFLAGS += $(BIN_CFLAGS)
>  LDFLAGS += $(BIN_LDFLAGS)
>  LIBDEPS += -L$(multipathdir) -lmultipath -L$(mpathcmddir) -lmpathcmd \
>  	-lpthread -ldevmapper -ldl -ludev
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 1449080..c937cd5 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -1,30 +1,31 @@
>  include ../Makefile.inc
>  
>  ifneq ($(call check_func,dm_task_get_errno,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
> -	CFLAGS += -DLIBDM_API_GET_ERRNO
> +	CPPFLAGS += -DLIBDM_API_GET_ERRNO
>  endif
>  
>  ifneq ($(call check_var,ELS_DTAG_LNK_INTEGRITY,$(LINUX_HEADERS_INCDIR)/scsi/fc/fc_els.h),0)
> -	CFLAGS += -DFPIN_EVENT_HANDLER
> +	CPPFLAGS += -DFPIN_EVENT_HANDLER
>  	FPIN_SUPPORT = 1
>  endif
>  #
>  # debugging stuff
>  #
> -#CFLAGS += -DLCKDBG
> -#CFLAGS += -D_DEBUG_
> -#CFLAGS += -DLOGDBG
> -CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir) \
> -	  -I$(mpathcmddir) -I$(thirdpartydir)
> +#CPPFLAGS += -DLCKDBG
> +#CPPFLAGS += -D_DEBUG_
> +#CPPFLAGS += -DLOGDBG
> +
> +CPPFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir) -I$(thirdpartydir) \
> +	$(shell $(PKGCONFIG) --modversion liburcu 2>/dev/null | \
> +		awk -F. '{ printf("-DURCU_VERSION=0x%06x", 256 * ( 256 * $$1 + $$2) + $$3); }')
> +CFLAGS += $(BIN_CFLAGS)
>  LDFLAGS += $(BIN_LDFLAGS)
>  LIBDEPS += -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist \
>  	   -L$(mpathcmddir) -lmpathcmd -ludev -ldl -lurcu -lpthread \
>  	   -ldevmapper -lreadline
> -CFLAGS += $(shell $(PKGCONFIG) --modversion liburcu 2>/dev/null | \
> -	awk -F. '{ printf("-DURCU_VERSION=0x%06x", 256 * ( 256 * $$1 + $$2) + $$3); }')
>  
>  ifdef SYSTEMD
> -	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
> +	CPPFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
>  	ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
>  		LIBDEPS += -lsystemd
>  	else
> @@ -32,7 +33,7 @@ ifdef SYSTEMD
>  	endif
>  endif
>  ifeq ($(ENABLE_DMEVENTS_POLL),0)
> -	CFLAGS += -DNO_DMEVENTS_POLL
> +	CPPFLAGS += -DNO_DMEVENTS_POLL
>  endif
>  
>  OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o waiter.o \
> diff --git a/tests/Makefile b/tests/Makefile
> index a069e37..d20ef23 100644
> --- a/tests/Makefile
> +++ b/tests/Makefile
> @@ -11,8 +11,8 @@ TEST_MISSING_INITIALIZERS = $(shell \
>  	|| echo -Wno-missing-field-initializers)
>  W_MISSING_INITIALIZERS := $(call TEST_MISSING_INITIALIZERS)
>  
> -CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) \
> -	-Wno-unused-parameter $(W_MISSING_INITIALIZERS) -DTESTCONFDIR=\"$(TESTDIR)/conf.d\"
> +CPPFLAGS += -I$(multipathdir) -I$(mpathcmddir) -DTESTCONFDIR=\"$(TESTDIR)/conf.d\"
> +CFLAGS += $(BIN_CFLAGS) -Wno-unused-parameter $(W_MISSING_INITIALIZERS)
>  LIBDEPS += -L. -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
>  
>  TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

