Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A58BC433C1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 04:25:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CE1CA61982
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 04:25:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE1CA61982
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617078328;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+S3M7pJij5W6v4WLm9JCyfa+iLKjzmb+L8z+TtpYXwI=;
	b=Z/98iFYyRz1/8pgGmyOFSanvpaGrkxENQ82mO3VwZTdgERZBuVKOhAJucqgpg2QfJADU4/
	VxwJPjs+IugvKhLODFeIVW42dn4LM5jjcG2xe5eDDkh4S4C4f4jL05rtACbSeXKltLsYL8
	p0kRQ1WNYDtgsO1O9SGfhP0FyabAkrA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-C43B7OimNkiNQpMVuqXddg-1; Tue, 30 Mar 2021 00:25:25 -0400
X-MC-Unique: C43B7OimNkiNQpMVuqXddg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4006680F054;
	Tue, 30 Mar 2021 04:25:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF30C5D9F0;
	Tue, 30 Mar 2021 04:25:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E1C0E1809C83;
	Tue, 30 Mar 2021 04:25:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U4PFB2027401 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 00:25:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DC33370953; Tue, 30 Mar 2021 04:25:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B75660D79;
	Tue, 30 Mar 2021 04:25:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12U4PA61006891; 
	Mon, 29 Mar 2021 23:25:10 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12U4PAne006890;
	Mon, 29 Mar 2021 23:25:10 -0500
Date: Mon, 29 Mar 2021 23:25:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210330042510.GN15006@octiron.msp.redhat.com>
References: <20210326212944.3136-1-mwilck@suse.com>
	<20210326212944.3136-5-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210326212944.3136-5-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [dm-devel] [PATCH 4/7] libdmmp: allow building without perl
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 26, 2021 at 10:29:41PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Add the kernel-doc generated manpages of libdmmp to git, and
> change the libdmmp Makefile to regenerate them (only) when
> necessary.
> 
> This allows us to drop perl as a build-time requirement.

Git complains about a bunch of trailing whitespace issues here, but this
is a great idea.

-Ben

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libdmmp/Makefile                              | 37 ++++++-------
>  libdmmp/docs/man/dmmp_context_free.3          | 15 ++++++
>  libdmmp/docs/man/dmmp_context_log_func_set.3  | 21 ++++++++
>  .../docs/man/dmmp_context_log_priority_get.3  | 23 ++++++++
>  .../docs/man/dmmp_context_log_priority_set.3  | 29 ++++++++++
>  libdmmp/docs/man/dmmp_context_new.3           | 19 +++++++
>  libdmmp/docs/man/dmmp_context_timeout_get.3   | 15 ++++++
>  libdmmp/docs/man/dmmp_context_timeout_set.3   | 19 +++++++
>  libdmmp/docs/man/dmmp_context_userdata_get.3  | 15 ++++++
>  libdmmp/docs/man/dmmp_context_userdata_set.3  | 18 +++++++
>  libdmmp/docs/man/dmmp_flush_mpath.3           | 36 +++++++++++++
>  libdmmp/docs/man/dmmp_last_error_msg.3        | 16 ++++++
>  libdmmp/docs/man/dmmp_log_priority_str.3      | 24 +++++++++
>  libdmmp/docs/man/dmmp_mpath_array_free.3      | 18 +++++++
>  libdmmp/docs/man/dmmp_mpath_array_get.3       | 36 +++++++++++++
>  libdmmp/docs/man/dmmp_mpath_kdev_name_get.3   | 17 ++++++
>  libdmmp/docs/man/dmmp_mpath_name_get.3        | 18 +++++++
>  libdmmp/docs/man/dmmp_mpath_wwid_get.3        | 13 +++++
>  libdmmp/docs/man/dmmp_path_array_get.3        | 25 +++++++++
>  libdmmp/docs/man/dmmp_path_blk_name_get.3     | 17 ++++++
>  libdmmp/docs/man/dmmp_path_group_array_get.3  | 27 ++++++++++
>  libdmmp/docs/man/dmmp_path_group_id_get.3     | 18 +++++++
>  .../docs/man/dmmp_path_group_priority_get.3   | 16 ++++++
>  .../docs/man/dmmp_path_group_selector_get.3   | 16 ++++++
>  libdmmp/docs/man/dmmp_path_group_status_get.3 | 23 ++++++++
>  libdmmp/docs/man/dmmp_path_group_status_str.3 | 26 +++++++++
>  libdmmp/docs/man/dmmp_path_status_get.3       | 54 +++++++++++++++++++
>  libdmmp/docs/man/dmmp_path_status_str.3       | 34 ++++++++++++
>  libdmmp/docs/man/dmmp_reconfig.3              | 27 ++++++++++
>  libdmmp/docs/man/dmmp_strerror.3              | 33 ++++++++++++
>  libdmmp/docs/{ => man}/libdmmp.h.3            |  0
>  31 files changed, 683 insertions(+), 22 deletions(-)
>  create mode 100644 libdmmp/docs/man/dmmp_context_free.3
>  create mode 100644 libdmmp/docs/man/dmmp_context_log_func_set.3
>  create mode 100644 libdmmp/docs/man/dmmp_context_log_priority_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_context_log_priority_set.3
>  create mode 100644 libdmmp/docs/man/dmmp_context_new.3
>  create mode 100644 libdmmp/docs/man/dmmp_context_timeout_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_context_timeout_set.3
>  create mode 100644 libdmmp/docs/man/dmmp_context_userdata_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_context_userdata_set.3
>  create mode 100644 libdmmp/docs/man/dmmp_flush_mpath.3
>  create mode 100644 libdmmp/docs/man/dmmp_last_error_msg.3
>  create mode 100644 libdmmp/docs/man/dmmp_log_priority_str.3
>  create mode 100644 libdmmp/docs/man/dmmp_mpath_array_free.3
>  create mode 100644 libdmmp/docs/man/dmmp_mpath_array_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_mpath_name_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_mpath_wwid_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_path_array_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_path_blk_name_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_path_group_array_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_path_group_id_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_path_group_priority_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_path_group_selector_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_path_group_status_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_path_group_status_str.3
>  create mode 100644 libdmmp/docs/man/dmmp_path_status_get.3
>  create mode 100644 libdmmp/docs/man/dmmp_path_status_str.3
>  create mode 100644 libdmmp/docs/man/dmmp_reconfig.3
>  create mode 100644 libdmmp/docs/man/dmmp_strerror.3
>  rename libdmmp/docs/{ => man}/libdmmp.h.3 (100%)
> 
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index 4175c3f..764a0bc 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -21,12 +21,13 @@ CFLAGS += $(LIB_CFLAGS) -fvisibility=hidden -I$(libdmmpdir) -I$(mpathcmddir) \
>  LIBDEPS += $(shell $(PKGCONFIG) --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthread
>  
>  all: $(LIBS) doc
> +.PHONY:	doc doc.gz clean install uninstall check speed_test dep_clean
>  
>  $(LIBS): $(OBJS)
>  	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
>  	$(LN) $@ $(DEVLIB)
>  
> -install:
> +install:	doc.gz
>  	mkdir -p $(DESTDIR)$(usrlibdir)
>  	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(usrlibdir)/$(LIBS)
>  	$(INSTALL_PROGRAM) -m 644 -D \
> @@ -40,11 +41,7 @@ install:
>  		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
>  	perl -i -pe 's|__INCLUDEDIR__|$(includedir)|g' \
>  		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
> -	@for file in docs/man/*.3.gz; do \
> -		$(INSTALL_PROGRAM) -m 644 -D \
> -			$$file \
> -			$(DESTDIR)$(man3dir)/ || exit $?; \
> -	done
> +	$(INSTALL_PROGRAM) -m 644 -t $(DESTDIR)$(man3dir) docs/man/*.3.gz
>  
>  uninstall:
>  	$(RM) $(DESTDIR)$(usrlibdir)/$(LIBS)
> @@ -58,7 +55,7 @@ uninstall:
>  
>  clean: dep_clean
>  	$(RM) core *.a *.o *.gz *.so *.so.*
> -	$(RM) -r docs/man
> +	$(RM) docs/man/*.gz
>  	$(MAKE) -C test clean
>  
>  include $(wildcard $(OBJS:.o=.d))
> @@ -69,23 +66,19 @@ check: all
>  speed_test: all
>  	$(MAKE) -C test speed_test
>  
> -doc: docs/man/$(EXTRA_MAN_FILES).gz
> +doc.gz:	doc $(patsubst %,%.gz,$(wildcard docs/man/*.3))
>  
> -TEMPFILE := $(shell mktemp)
> +doc: docs/man/dmmp_strerror.3
>  
> -docs/man/$(EXTRA_MAN_FILES).gz: $(HEADERS)
> -	@for file in $(EXTRA_MAN_FILES); do \
> -		$(INSTALL_PROGRAM) -v -m 644 -D docs/$$file docs/man/$$file; \
> -	done
> -	cat $(HEADERS) | \
> -	    perl docs/doc-preclean.pl > "$(TEMPFILE)"
> -	perl docs/kernel-doc -man "$(TEMPFILE)" | \
> -	    perl docs/split-man.pl docs/man
> -	-rm -f "$(TEMPFILE)"
> -	@for file in docs/man/*.3; do \
> -		gzip -f $$file; \
> -	done
> -	find docs/man -type f -name \*[0-9].gz
> +docs/man/%.3.gz:	docs/man/%.3
> +	gzip -c $< >$@
> +
> +docs/man/dmmp_strerror.3:	$(HEADERS)
> +	TEMPFILE=$(shell mktemp); \
> +	cat $^ | perl docs/doc-preclean.pl >$$TEMPFILE; \
> +	perl docs/kernel-doc -man $$TEMPFILE | \
> +	    perl docs/split-man.pl docs/man; \
> +	rm -f $$TEMPFILE
>  
>  dep_clean:
>  	$(RM) $(OBJS:.o=.d)
> diff --git a/libdmmp/docs/man/dmmp_context_free.3 b/libdmmp/docs/man/dmmp_context_free.3
> new file mode 100644
> index 0000000..0d26f42
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_context_free.3
> @@ -0,0 +1,15 @@
> +.TH "dmmp_context_free" 3 "dmmp_context_free" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_context_free \- Release the memory of struct dmmp_context.
> +.SH SYNOPSIS
> +.B "void" dmmp_context_free
> +.BI "(struct dmmp_context *" ctx ");"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +.SH "DESCRIPTION"
> +
> +Release the memory of struct dmmp_context, but the userdata memory defined
> +via \fBdmmp_context_userdata_set\fP will not be touched.
> +.SH "RETURN"
> +void
> diff --git a/libdmmp/docs/man/dmmp_context_log_func_set.3 b/libdmmp/docs/man/dmmp_context_log_func_set.3
> new file mode 100644
> index 0000000..986793d
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_context_log_func_set.3
> @@ -0,0 +1,21 @@
> +.TH "dmmp_context_log_func_set" 3 "dmmp_context_log_func_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_context_log_func_set \- Set log handler function.
> +.SH SYNOPSIS
> +.B "void" dmmp_context_log_func_set
> +.BI "(struct dmmp_context *" ctx ","
> +.BI "void (*" log_func ") (struct dmmp_context *ctx, int priority, const char *file, int line, const char *func_name, const char *format, va_list args));"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.IP "log_func" 12
> +Pointer of log handler function. If set to NULL, all log will be
> +ignored.
> +.SH "DESCRIPTION"
> +
> +Set custom log handler. The log handler will be invoked when log message
> +is equal or more important(less value) than log priority setting.
> +Please check manpage libdmmp.h(3) for detail usage.
> +.SH "RETURN"
> +void
> diff --git a/libdmmp/docs/man/dmmp_context_log_priority_get.3 b/libdmmp/docs/man/dmmp_context_log_priority_get.3
> new file mode 100644
> index 0000000..9a273a2
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_context_log_priority_get.3
> @@ -0,0 +1,23 @@
> +.TH "dmmp_context_log_priority_get" 3 "dmmp_context_log_priority_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_context_log_priority_get \- Get log priority.
> +.SH SYNOPSIS
> +.B "int" dmmp_context_log_priority_get
> +.BI "(struct dmmp_context *" ctx ");"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Retrieve current log priority. Valid log priority values are:
> +
> +* DMMP_LOG_PRIORITY_ERROR -- 3
> +
> +* DMMP_LOG_PRIORITY_WARNING -- 4
> +
> +* DMMP_LOG_PRIORITY_INFO -- 5
> +
> +* DMMP_LOG_PRIORITY_DEBUG -- 7
> +.SH "RETURN"
> +int, log priority.
> diff --git a/libdmmp/docs/man/dmmp_context_log_priority_set.3 b/libdmmp/docs/man/dmmp_context_log_priority_set.3
> new file mode 100644
> index 0000000..469c5a4
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_context_log_priority_set.3
> @@ -0,0 +1,29 @@
> +.TH "dmmp_context_log_priority_set" 3 "dmmp_context_log_priority_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_context_log_priority_set \- Set log priority.
> +.SH SYNOPSIS
> +.B "void" dmmp_context_log_priority_set
> +.BI "(struct dmmp_context *" ctx ","
> +.BI "int " priority ");"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.IP "priority" 12
> +int, log priority.
> +.SH "DESCRIPTION"
> +
> +
> +When library generates log message, only equal or more important(less value)
> +message will be forwarded to log handler function. Valid log priority values
> +are:
> +
> +* DMMP_LOG_PRIORITY_ERROR -- 3
> +
> +* DMMP_LOG_PRIORITY_WARNING -- 4
> +
> +* DMMP_LOG_PRIORITY_INFO -- 5
> +
> +* DMMP_LOG_PRIORITY_DEBUG -- 7
> +.SH "RETURN"
> +void
> diff --git a/libdmmp/docs/man/dmmp_context_new.3 b/libdmmp/docs/man/dmmp_context_new.3
> new file mode 100644
> index 0000000..0eaeb00
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_context_new.3
> @@ -0,0 +1,19 @@
> +.TH "dmmp_context_new" 3 "dmmp_context_new" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_context_new \- Create struct dmmp_context.
> +.SH SYNOPSIS
> +.B "struct dmmp_context *" dmmp_context_new
> +.BI "(" void ");"
> +.SH ARGUMENTS
> +.IP "void" 12
> +no arguments
> +.SH "DESCRIPTION"
> +
> +The default logging level (DMMP_LOG_PRIORITY_DEFAULT) is
> +DMMP_LOG_PRIORITY_WARNING which means only warning and error message will be
> +forward to log handler function.  The default log handler function will print
> +log message to STDERR, to change so, please use \fBdmmp_context_log_func_set\fP
> +to set your own log handler, check manpage libdmmp.h(3) for detail.
> +.SH "RETURN"
> +Pointer of 'struct dmmp_context'. Should be freed by
> +\fBdmmp_context_free\fP.
> diff --git a/libdmmp/docs/man/dmmp_context_timeout_get.3 b/libdmmp/docs/man/dmmp_context_timeout_get.3
> new file mode 100644
> index 0000000..1df2793
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_context_timeout_get.3
> @@ -0,0 +1,15 @@
> +.TH "dmmp_context_timeout_get" 3 "dmmp_context_timeout_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_context_timeout_get \- Get IPC timeout.
> +.SH SYNOPSIS
> +.B "unsigned int" dmmp_context_timeout_get
> +.BI "(struct dmmp_context *" ctx ");"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Retrieve timeout value of IPC connection to multipathd daemon.
> +.SH "RETURN"
> +unsigned int. Timeout in milliseconds.
> diff --git a/libdmmp/docs/man/dmmp_context_timeout_set.3 b/libdmmp/docs/man/dmmp_context_timeout_set.3
> new file mode 100644
> index 0000000..f3d7709
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_context_timeout_set.3
> @@ -0,0 +1,19 @@
> +.TH "dmmp_context_timeout_set" 3 "dmmp_context_timeout_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_context_timeout_set \- Set IPC timeout.
> +.SH SYNOPSIS
> +.B "void" dmmp_context_timeout_set
> +.BI "(struct dmmp_context *" ctx ","
> +.BI "unsigned int " tmo ");"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.IP "tmo" 12
> +Timeout in milliseconds(1 seconds equal 1000 milliseconds).
> +0 means infinite, function only return when error or pass.
> +.SH "DESCRIPTION"
> +
> +By default, the IPC to multipathd daemon will timeout after 60 seconds.
> +.SH "RETURN"
> +void
> diff --git a/libdmmp/docs/man/dmmp_context_userdata_get.3 b/libdmmp/docs/man/dmmp_context_userdata_get.3
> new file mode 100644
> index 0000000..fb713d5
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_context_userdata_get.3
> @@ -0,0 +1,15 @@
> +.TH "dmmp_context_userdata_get" 3 "dmmp_context_userdata_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_context_userdata_get \- Get user data pointer.
> +.SH SYNOPSIS
> +.B "void *" dmmp_context_userdata_get
> +.BI "(struct dmmp_context *" ctx ");"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Retrieve user data pointer from 'struct dmmp_context'.
> +.SH "RETURN"
> +void *. Pointer of user defined data.
> diff --git a/libdmmp/docs/man/dmmp_context_userdata_set.3 b/libdmmp/docs/man/dmmp_context_userdata_set.3
> new file mode 100644
> index 0000000..c5bf63f
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_context_userdata_set.3
> @@ -0,0 +1,18 @@
> +.TH "dmmp_context_userdata_set" 3 "dmmp_context_userdata_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_context_userdata_set \- Set user data pointer.
> +.SH SYNOPSIS
> +.B "void" dmmp_context_userdata_set
> +.BI "(struct dmmp_context *" ctx ","
> +.BI "void *" userdata ");"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.IP "userdata" 12
> +Pointer of user defined data.
> +.SH "DESCRIPTION"
> +
> +Store user data pointer into 'struct dmmp_context'.
> +.SH "RETURN"
> +void
> diff --git a/libdmmp/docs/man/dmmp_flush_mpath.3 b/libdmmp/docs/man/dmmp_flush_mpath.3
> new file mode 100644
> index 0000000..cdfd526
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_flush_mpath.3
> @@ -0,0 +1,36 @@
> +.TH "dmmp_flush_mpath" 3 "dmmp_flush_mpath" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_flush_mpath \- Flush specified multipath device map if unused.
> +.SH SYNOPSIS
> +.B "int" dmmp_flush_mpath
> +.BI "(struct dmmp_context *" ctx ","
> +.BI "const char *" mpath_name ");"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.IP "mpath_name" 12
> +const char *. The name of multipath device map.
> +.SH "DESCRIPTION"
> +
> +Flush a multipath device map specified as parameter, if unused.
> +.SH "RETURN"
> +int. Valid error codes are:
> +
> +* DMMP_OK
> +
> +* DMMP_ERR_BUG
> +
> +* DMMP_ERR_NO_MEMORY
> +
> +* DMMP_ERR_NO_DAEMON
> +
> +* DMMP_ERR_MPATH_BUSY
> +
> +* DMMP_ERR_MPATH_NOT_FOUND
> +
> +* DMMP_ERR_INVALID_ARGUMENT
> +
> +* DMMP_ERR_PERMISSION_DENY
> +
> +Error number could be converted to string by \fBdmmp_strerror\fP.
> diff --git a/libdmmp/docs/man/dmmp_last_error_msg.3 b/libdmmp/docs/man/dmmp_last_error_msg.3
> new file mode 100644
> index 0000000..20acbc6
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_last_error_msg.3
> @@ -0,0 +1,16 @@
> +.TH "dmmp_last_error_msg" 3 "dmmp_last_error_msg" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_last_error_msg \- Retrieves the last error message.
> +.SH SYNOPSIS
> +.B "const char *" dmmp_last_error_msg
> +.BI "(struct dmmp_context *" ctx ");"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Retrieves the last error message.
> +.SH "RETURN"
> +const char *. No need to free this memory, the resources will get
> +freed when \fBdmmp_context_free\fP.
> diff --git a/libdmmp/docs/man/dmmp_log_priority_str.3 b/libdmmp/docs/man/dmmp_log_priority_str.3
> new file mode 100644
> index 0000000..3b5f828
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_log_priority_str.3
> @@ -0,0 +1,24 @@
> +.TH "dmmp_log_priority_str" 3 "dmmp_log_priority_str" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_log_priority_str \- Convert log priority to string.
> +.SH SYNOPSIS
> +.B "const char *" dmmp_log_priority_str
> +.BI "(int " priority ");"
> +.SH ARGUMENTS
> +.IP "priority" 12
> +int. Log priority.
> +.SH "DESCRIPTION"
> +
> +Convert log priority to string (const char *).
> +.SH "RETURN"
> +const char *. Valid string are:
> +
> +* "ERROR" for DMMP_LOG_PRIORITY_ERROR
> +
> +* "WARN " for DMMP_LOG_PRIORITY_WARNING
> +
> +* "INFO " for DMMP_LOG_PRIORITY_INFO
> +
> +* "DEBUG" for DMMP_LOG_PRIORITY_DEBUG
> +
> +* "Invalid argument" for invalid log priority.
> diff --git a/libdmmp/docs/man/dmmp_mpath_array_free.3 b/libdmmp/docs/man/dmmp_mpath_array_free.3
> new file mode 100644
> index 0000000..8c294e0
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_mpath_array_free.3
> @@ -0,0 +1,18 @@
> +.TH "dmmp_mpath_array_free" 3 "dmmp_mpath_array_free" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_mpath_array_free \- Free 'struct dmmp_mpath' pointer array.
> +.SH SYNOPSIS
> +.B "void" dmmp_mpath_array_free
> +.BI "(struct dmmp_mpath **" dmmp_mps ","
> +.BI "uint32_t " dmmp_mp_count ");"
> +.SH ARGUMENTS
> +.IP "dmmp_mps" 12
> +Pointer of 'struct dmmp_mpath' array.
> +.IP "dmmp_mp_count" 12
> +uint32_t, the size of 'dmmp_mps' pointer array.
> +.SH "DESCRIPTION"
> +
> +Free the 'dmmp_mps' pointer array generated by \fBdmmp_mpath_array_get\fP.
> +If provided 'dmmp_mps' pointer is NULL or dmmp_mp_count == 0, do nothing.
> +.SH "RETURN"
> +void
> diff --git a/libdmmp/docs/man/dmmp_mpath_array_get.3 b/libdmmp/docs/man/dmmp_mpath_array_get.3
> new file mode 100644
> index 0000000..e211db4
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_mpath_array_get.3
> @@ -0,0 +1,36 @@
> +.TH "dmmp_mpath_array_get" 3 "dmmp_mpath_array_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_mpath_array_get \- Query all existing multipath devices.
> +.SH SYNOPSIS
> +.B "int" dmmp_mpath_array_get
> +.BI "(struct dmmp_context *" ctx ","
> +.BI "struct dmmp_mpath ***" dmmp_mps ","
> +.BI "uint32_t *" dmmp_mp_count ");"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.IP "dmmp_mps" 12
> +Output pointer array of 'struct dmmp_mpath'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.IP "dmmp_mp_count" 12
> +Output pointer of uint32_t. Hold the size of 'dmmp_mps' pointer array.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Query all existing multipath devices and store them into a pointer array.
> +The memory of 'dmmp_mps' should be freed via \fBdmmp_mpath_array_free\fP.
> +.SH "RETURN"
> +int. Valid error codes are:
> +
> +* DMMP_OK
> +
> +* DMMP_ERR_BUG
> +
> +* DMMP_ERR_NO_MEMORY
> +
> +* DMMP_ERR_NO_DAEMON
> +
> +* DMMP_ERR_INCONSISTENT_DATA
> +
> +Error number could be converted to string by \fBdmmp_strerror\fP.
> diff --git a/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3 b/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
> new file mode 100644
> index 0000000..e802fe6
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
> @@ -0,0 +1,17 @@
> +.TH "dmmp_mpath_kdev_name_get" 3 "dmmp_mpath_kdev_name_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_mpath_kdev_name_get \- Retrieve kernel DEVNAME of certain mpath.
> +.SH SYNOPSIS
> +.B "const char *" dmmp_mpath_kdev_name_get
> +.BI "(struct dmmp_mpath *" dmmp_mp ");"
> +.SH ARGUMENTS
> +.IP "dmmp_mp" 12
> +Pointer of 'struct dmmp_mpath'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Retrieve DEVNAME name used by kernel uevent of specified mpath.
> +For example: 'dm-1'.
> +.SH "RETURN"
> +const char *. No need to free this memory, the resources will get
> +freed when \fBdmmp_mpath_array_free\fP.
> diff --git a/libdmmp/docs/man/dmmp_mpath_name_get.3 b/libdmmp/docs/man/dmmp_mpath_name_get.3
> new file mode 100644
> index 0000000..d70579e
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_mpath_name_get.3
> @@ -0,0 +1,18 @@
> +.TH "dmmp_mpath_name_get" 3 "dmmp_mpath_name_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_mpath_name_get \- Retrieve name(alias) of certain mpath.
> +.SH SYNOPSIS
> +.B "const char *" dmmp_mpath_name_get
> +.BI "(struct dmmp_mpath *" dmmp_mp ");"
> +.SH ARGUMENTS
> +.IP "dmmp_mp" 12
> +Pointer of 'struct dmmp_mpath'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Retrieve the name (also known as alias) of certain mpath.
> +When the config 'user_friendly_names' been set 'no', the name will be
> +identical to WWID retrieved by \fBdmmp_mpath_wwid_get\fP.
> +.SH "RETURN"
> +const char *. No need to free this memory, the resources will get
> +freed when \fBdmmp_mpath_array_free\fP.
> diff --git a/libdmmp/docs/man/dmmp_mpath_wwid_get.3 b/libdmmp/docs/man/dmmp_mpath_wwid_get.3
> new file mode 100644
> index 0000000..3d060e9
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_mpath_wwid_get.3
> @@ -0,0 +1,13 @@
> +.TH "dmmp_mpath_wwid_get" 3 "dmmp_mpath_wwid_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_mpath_wwid_get \- Retrieve WWID of certain mpath.
> +.SH SYNOPSIS
> +.B "const char *" dmmp_mpath_wwid_get
> +.BI "(struct dmmp_mpath *" dmmp_mp ");"
> +.SH ARGUMENTS
> +.IP "dmmp_mp" 12
> +Pointer of 'struct dmmp_mpath'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "RETURN"
> +const char *. No need to free this memory, the resources will get
> +freed when \fBdmmp_mpath_array_free\fP.
> diff --git a/libdmmp/docs/man/dmmp_path_array_get.3 b/libdmmp/docs/man/dmmp_path_array_get.3
> new file mode 100644
> index 0000000..53340b3
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_path_array_get.3
> @@ -0,0 +1,25 @@
> +.TH "dmmp_path_array_get" 3 "dmmp_path_array_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_path_array_get \- Retrieve path pointer array.
> +.SH SYNOPSIS
> +.B "void" dmmp_path_array_get
> +.BI "(struct dmmp_path_group *" dmmp_pg ","
> +.BI "struct dmmp_path ***" dmmp_ps ","
> +.BI "uint32_t *" dmmp_p_count ");"
> +.SH ARGUMENTS
> +.IP "dmmp_pg" 12
> +Pointer of 'struct dmmp_path_group'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.IP "dmmp_ps" 12
> +Output pointer of 'struct dmmp_path' pointer array.
> +If this pointer is NULL, your program will be terminated by assert.
> +.IP "dmmp_p_count" 12
> +Output pointer of uint32_t. Hold the size of 'dmmp_ps' pointer array.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +The memory of output pointer array is hold by 'struct dmmp_mpath', no
> +need to free this memory, the resources will got freed when
> +\fBdmmp_mpath_array_free\fP.
> +.SH "RETURN"
> +void
> diff --git a/libdmmp/docs/man/dmmp_path_blk_name_get.3 b/libdmmp/docs/man/dmmp_path_blk_name_get.3
> new file mode 100644
> index 0000000..da5f9f0
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_path_blk_name_get.3
> @@ -0,0 +1,17 @@
> +.TH "dmmp_path_blk_name_get" 3 "dmmp_path_blk_name_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_path_blk_name_get \- Retrieve block name.
> +.SH SYNOPSIS
> +.B "const char *" dmmp_path_blk_name_get
> +.BI "(struct dmmp_path *" dmmp_p ");"
> +.SH ARGUMENTS
> +.IP "dmmp_p" 12
> +Pointer of 'struct dmmp_path'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Retrieve block name of certain path. The example of block names are "sda",
> +"nvme0n1".
> +.SH "RETURN"
> +const char *. No need to free this memory, the resources will get
> +freed when \fBdmmp_mpath_array_free\fP.
> diff --git a/libdmmp/docs/man/dmmp_path_group_array_get.3 b/libdmmp/docs/man/dmmp_path_group_array_get.3
> new file mode 100644
> index 0000000..6eee4a2
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_path_group_array_get.3
> @@ -0,0 +1,27 @@
> +.TH "dmmp_path_group_array_get" 3 "dmmp_path_group_array_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_path_group_array_get \- Retrieve path groups pointer array.
> +.SH SYNOPSIS
> +.B "void" dmmp_path_group_array_get
> +.BI "(struct dmmp_mpath *" dmmp_mp ","
> +.BI "struct dmmp_path_group ***" dmmp_pgs ","
> +.BI "uint32_t *" dmmp_pg_count ");"
> +.SH ARGUMENTS
> +.IP "dmmp_mp" 12
> +Pointer of 'struct dmmp_mpath'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.IP "dmmp_pgs" 12
> +Output pointer of 'struct dmmp_path_group' pointer array.
> +If this pointer is NULL, your program will be terminated by assert.
> +.IP "dmmp_pg_count" 12
> +Output pointer of uint32_t. Hold the size of 'dmmp_pgs' pointer array.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Retrieve the path groups of certain mpath.
> +
> +The memory of output pointer array is hold by 'struct dmmp_mpath', no
> +need to free this memory, the resources will got freed when
> +\fBdmmp_mpath_array_free\fP.
> +.SH "RETURN"
> +void
> diff --git a/libdmmp/docs/man/dmmp_path_group_id_get.3 b/libdmmp/docs/man/dmmp_path_group_id_get.3
> new file mode 100644
> index 0000000..4f07b53
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_path_group_id_get.3
> @@ -0,0 +1,18 @@
> +.TH "dmmp_path_group_id_get" 3 "dmmp_path_group_id_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_path_group_id_get \- Retrieve path group ID.
> +.SH SYNOPSIS
> +.B "uint32_t" dmmp_path_group_id_get
> +.BI "(struct dmmp_path_group *" dmmp_pg ");"
> +.SH ARGUMENTS
> +.IP "dmmp_pg" 12
> +Pointer of 'struct dmmp_path_group'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Retrieve the path group ID which could be used to switch active path group
> +via command:
> +
> +multipathd -k'switch multipath mpathb group $id'
> +.SH "RETURN"
> +uint32_t.
> diff --git a/libdmmp/docs/man/dmmp_path_group_priority_get.3 b/libdmmp/docs/man/dmmp_path_group_priority_get.3
> new file mode 100644
> index 0000000..a48b270
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_path_group_priority_get.3
> @@ -0,0 +1,16 @@
> +.TH "dmmp_path_group_priority_get" 3 "dmmp_path_group_priority_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_path_group_priority_get \- Retrieve path group priority.
> +.SH SYNOPSIS
> +.B "uint32_t" dmmp_path_group_priority_get
> +.BI "(struct dmmp_path_group *" dmmp_pg ");"
> +.SH ARGUMENTS
> +.IP "dmmp_pg" 12
> +Pointer of 'struct dmmp_path_group'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +The enabled path group with highest priority will be next active path group
> +if active path group down.
> +.SH "RETURN"
> +uint32_t.
> diff --git a/libdmmp/docs/man/dmmp_path_group_selector_get.3 b/libdmmp/docs/man/dmmp_path_group_selector_get.3
> new file mode 100644
> index 0000000..407b3f4
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_path_group_selector_get.3
> @@ -0,0 +1,16 @@
> +.TH "dmmp_path_group_selector_get" 3 "dmmp_path_group_selector_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_path_group_selector_get \- Retrieve path group selector.
> +.SH SYNOPSIS
> +.B "const char *" dmmp_path_group_selector_get
> +.BI "(struct dmmp_path_group *" dmmp_pg ");"
> +.SH ARGUMENTS
> +.IP "dmmp_pg" 12
> +Pointer of 'struct dmmp_path_group'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Path group selector determine which path in active path group will be
> +use to next I/O.
> +.SH "RETURN"
> +const char *.
> diff --git a/libdmmp/docs/man/dmmp_path_group_status_get.3 b/libdmmp/docs/man/dmmp_path_group_status_get.3
> new file mode 100644
> index 0000000..a81aeb3
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_path_group_status_get.3
> @@ -0,0 +1,23 @@
> +.TH "dmmp_path_group_status_get" 3 "dmmp_path_group_status_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_path_group_status_get \- Retrieve path group status.
> +.SH SYNOPSIS
> +.B "uint32_t" dmmp_path_group_status_get
> +.BI "(struct dmmp_path_group *" dmmp_pg ");"
> +.SH ARGUMENTS
> +.IP "dmmp_pg" 12
> +Pointer of 'struct dmmp_path_group'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +The valid path group statuses are:
> +
> +* DMMP_PATH_GROUP_STATUS_UNKNOWN
> +
> +* DMMP_PATH_GROUP_STATUS_ENABLED  -- standby to be active
> +
> +* DMMP_PATH_GROUP_STATUS_DISABLED -- disabled due to all path down
> +
> +* DMMP_PATH_GROUP_STATUS_ACTIVE -- selected to handle I/O
> +.SH "RETURN"
> +uint32_t.
> diff --git a/libdmmp/docs/man/dmmp_path_group_status_str.3 b/libdmmp/docs/man/dmmp_path_group_status_str.3
> new file mode 100644
> index 0000000..e4a9f74
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_path_group_status_str.3
> @@ -0,0 +1,26 @@
> +.TH "dmmp_path_group_status_str" 3 "dmmp_path_group_status_str" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_path_group_status_str \- Convert path group status to string.
> +.SH SYNOPSIS
> +.B "const char *" dmmp_path_group_status_str
> +.BI "(uint32_t " pg_status ");"
> +.SH ARGUMENTS
> +.IP "pg_status" 12
> +uint32_t. Path group status.
> +When provided value is not a valid path group status, return "Invalid
> +argument".
> +.SH "DESCRIPTION"
> +
> +Convert path group status uint32_t to string (const char *).
> +.SH "RETURN"
> +const char *. Valid string are:
> +
> +* "Invalid argument"
> +
> +* "undef"
> +
> +* "enabled"
> +
> +* "disabled"
> +
> +* "active"
> diff --git a/libdmmp/docs/man/dmmp_path_status_get.3 b/libdmmp/docs/man/dmmp_path_status_get.3
> new file mode 100644
> index 0000000..025cfee
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_path_status_get.3
> @@ -0,0 +1,54 @@
> +.TH "dmmp_path_status_get" 3 "dmmp_path_status_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_path_status_get \- Retrieve the path status.
> +.SH SYNOPSIS
> +.B "uint32_t" dmmp_path_status_get
> +.BI "(struct dmmp_path *" dmmp_p ");"
> +.SH ARGUMENTS
> +.IP "dmmp_p" 12
> +Pointer of 'struct dmmp_path'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +The valid path statuses are:
> +
> +* DMMP_PATH_STATUS_UNKNOWN
> +
> +* DMMP_PATH_STATUS_DOWN
> +
> +Path is down and you shouldn't try to send commands to it.
> +
> +* DMMP_PATH_STATUS_UP
> +
> +Path is up and I/O can be sent to it.
> +
> +* DMMP_PATH_STATUS_SHAKY
> +
> +Only emc_clariion checker when path not available for "normal"
> +operations.
> +
> +* DMMP_PATH_STATUS_GHOST
> +
> +Only hp_sw and rdac checkers.  Indicates a "passive/standby"
> +path on active/passive HP arrays. These paths will return valid
> +answers to certain SCSI commands (tur, read_capacity, inquiry,
> +start_stop), but will fail I/O commands.  The path needs an
> +initialization command to be sent to it in order for I/Os to
> +succeed.
> +
> +* DMMP_PATH_STATUS_PENDING
> +
> +Available for all async checkers when a check IO is in flight.
> +
> +* DMMP_PATH_STATUS_TIMEOUT
> +
> +Only tur checker when command timed out.
> +
> +* DMMP_PATH_STATUS_DELAYED
> +
> +If a path fails after being up for less than delay_watch_checks checks,
> +when it comes back up again, it will not be marked as up until it has
> +been up for delay_wait_checks checks. During this time, it is marked as
> +"delayed".
> +.SH "RETURN"
> +uint32_t.
> diff --git a/libdmmp/docs/man/dmmp_path_status_str.3 b/libdmmp/docs/man/dmmp_path_status_str.3
> new file mode 100644
> index 0000000..3944d39
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_path_status_str.3
> @@ -0,0 +1,34 @@
> +.TH "dmmp_path_status_str" 3 "dmmp_path_status_str" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_path_status_str \- Convert path status to string.
> +.SH SYNOPSIS
> +.B "const char *" dmmp_path_status_str
> +.BI "(uint32_t " path_status ");"
> +.SH ARGUMENTS
> +.IP "path_status" 12
> +uint32_t. Path status.
> +When provided value is not a valid path status, return
> +"Invalid argument".
> +.SH "DESCRIPTION"
> +
> +Convert path status uint32_t to string (const char *):
> +
> +* DMMP_PATH_STATUS_UNKNOWN -- "undef"
> +
> +* DMMP_PATH_STATUS_DOWN -- "faulty"
> +
> +* DMMP_PATH_STATUS_UP -- "ready"
> +
> +* DMMP_PATH_STATUS_SHAKY -- "shaky"
> +
> +* DMMP_PATH_STATUS_GHOST -- "ghost"
> +
> +* DMMP_PATH_STATUS_PENDING -- "pending"
> +
> +* DMMP_PATH_STATUS_TIMEOUT -- "timeout"
> +
> +* DMMP_PATH_STATUS_REMOVED -- "removed"
> +
> +* DMMP_PATH_STATUS_DELAYED -- "delayed"
> +.SH "RETURN"
> +const char *. The meaning of status value.
> diff --git a/libdmmp/docs/man/dmmp_reconfig.3 b/libdmmp/docs/man/dmmp_reconfig.3
> new file mode 100644
> index 0000000..a743e30
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_reconfig.3
> @@ -0,0 +1,27 @@
> +.TH "dmmp_reconfig" 3 "dmmp_reconfig" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_reconfig \- Instruct multipathd daemon to do reconfiguration.
> +.SH SYNOPSIS
> +.B "int" dmmp_reconfig
> +.BI "(struct dmmp_context *" ctx ");"
> +.SH ARGUMENTS
> +.IP "ctx" 12
> +Pointer of 'struct dmmp_context'.
> +If this pointer is NULL, your program will be terminated by assert.
> +.SH "DESCRIPTION"
> +
> +Instruct multipathd daemon to do reconfiguration.
> +.SH "RETURN"
> +int. Valid error codes are:
> +
> +* DMMP_OK
> +
> +* DMMP_ERR_BUG
> +
> +* DMMP_ERR_NO_MEMORY
> +
> +* DMMP_ERR_NO_DAEMON
> +
> +* DMMP_ERR_PERMISSION_DENY
> +
> +Error number could be converted to string by \fBdmmp_strerror\fP.
> diff --git a/libdmmp/docs/man/dmmp_strerror.3 b/libdmmp/docs/man/dmmp_strerror.3
> new file mode 100644
> index 0000000..4d753d3
> --- /dev/null
> +++ b/libdmmp/docs/man/dmmp_strerror.3
> @@ -0,0 +1,33 @@
> +.TH "dmmp_strerror" 3 "dmmp_strerror" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.SH NAME
> +dmmp_strerror \- Convert error code to string.
> +.SH SYNOPSIS
> +.B "const char *" dmmp_strerror
> +.BI "(int " rc ");"
> +.SH ARGUMENTS
> +.IP "rc" 12
> +int. Return code by libdmmp functions. When provided error code is not a
> +valid error code, return "Invalid argument".
> +.SH "DESCRIPTION"
> +
> +Convert error code (int) to string (const char *):
> +
> +* DMMP_OK -- "OK"
> +
> +* DMMP_ERR_BUG -- "BUG of libdmmp library"
> +
> +* DMMP_ERR_NO_MEMORY -- "Out of memory"
> +
> +* DMMP_ERR_IPC_TIMEOUT -- "Timeout when communicate with multipathd,
> +try to set bigger timeout value via dmmp_context_timeout_set ()"
> +
> +* DMMP_ERR_IPC_ERROR -- "Error when communicate with multipathd daemon"
> +
> +* DMMP_ERR_NO_DAEMON -- "The multipathd daemon not started"
> +
> +* DMMP_ERR_INCOMPATIBLE -- "The multipathd daemon version is not
> +compatible with current library"
> +
> +* Other invalid error number -- "Invalid argument"
> +.SH "RETURN"
> +const char *. The meaning of provided error code.
> diff --git a/libdmmp/docs/libdmmp.h.3 b/libdmmp/docs/man/libdmmp.h.3
> similarity index 100%
> rename from libdmmp/docs/libdmmp.h.3
> rename to libdmmp/docs/man/libdmmp.h.3
> -- 
> 2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

