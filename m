Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C319232C84
	for <dm-devel@lists.linux.dev>; Mon, 27 Nov 2023 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b1bnUtaf"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7b395875bb8so67449139f.1
        for <dm-devel@lists.linux.dev>; Mon, 27 Nov 2023 14:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701122877; x=1701727677; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DzjD5HIQjqJ3WLRbAumDN9OSYQ6P8ovX6zoY930D8Qo=;
        b=b1bnUtafee92o95bOcWHdVPlfwsvOcgx1xrgNYbsGNIYtn4tAbxUf+yLNDMM1NLSKL
         z2aQv7ESkBVLI10oVvWoi/2rjPbe4F7/uD2YGHmgIB53mUEnKUdoQAKc4Ot2cQ3Vu/1g
         gFWNrwBzLa9B6FUxFRZzc5eVq+RjvXjojx2eOolfFknO2tuWZ2blyGakkpYYlVe0zuf+
         mE+f2m953FPHIOeRsE0VaA7GsG9K4+fvK9IB7xEP1AJs4hpAzz2chKobdJ+vU/WKkxKw
         9Fy926TWRTnXJD45iD+JM+GZ7Te+sdg4MKhs4XXBKF03yIR6dY8WN4SsCg/sRHV78lxj
         5p7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701122877; x=1701727677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DzjD5HIQjqJ3WLRbAumDN9OSYQ6P8ovX6zoY930D8Qo=;
        b=OJEDyngXebRDpdWeAL90mEQz7CJd2h9tq+FsaIgJGEM7klDnduZfvMHKEylQppF5l2
         qNCZIrbymYR4wwHDPwjZMxH1VswGU27hULAWFPQAud61qnywoGDOpnMcaN3fc4OhR379
         dwh9rg5+G7XV3pqiHN/7e7PElJjIad10Z5aiJgzkiq2d1dgbVfjkmUYeQzazT4Ghonc8
         UeuWJf2mwQw5/JptCV0+9WOECbeLBDz5ZWJlKdEe7z1t9Ee6XqBfgwjgCUlzuc9ZKk74
         r5OYzH2ZCkWNt8sGpmg9pk0cRHX/CGMX37SIEHtrJX++8yA2j5tj1KyjHJxYo5bi8KzM
         DoHQ==
X-Gm-Message-State: AOJu0Yx+UwP+CF6Idvb2gH3cu19KEk0r658l1LOHq6XQbYDzQVKM7aNJ
	+vXbeNiCef2Z3lEszjWutsTSZNKySfFUlXeeHfMABEsk
X-Google-Smtp-Source: AGHT+IGrOQZy1oqS9pWA1DVSwabXSQeI5hN94PFsRANT0f2Mgs6lqTQ/k7MnjanJQ0A8ISoTLOW4qBpS+QTFh2Vw1YQ=
X-Received: by 2002:a6b:510c:0:b0:7b3:9358:db2f with SMTP id
 f12-20020a6b510c000000b007b39358db2fmr9501081iob.17.1701122876713; Mon, 27
 Nov 2023 14:07:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231127215418.271708-1-bmarzins@redhat.com>
In-Reply-To: <20231127215418.271708-1-bmarzins@redhat.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Mon, 27 Nov 2023 16:07:46 -0600
Message-ID: <CAAMCDeer-7Nw72UBdQGeT_EsGfXUj=L5RshvDsPCp+5QNY2eyQ@mail.gmail.com>
Subject: Re: [PATCH] multipathd: Make sure to disable queueing if recovery has failed.
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	device-mapper development <dm-devel@lists.linux.dev>, Martin Wilck <Martin.Wilck@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

How long does recovery take?     I am unclear on when the explictly
set queue_if_no_path is being overridden, and why disabling it is
useful.

Typically we are setting queue_if_no_path to forever with the intent
that it will survive longer storage and/or disk issues without
returning an error to the application and/or corrupting fses if the
storage issue can be fixed.

We generally expect it to recover when the storage comes back, but
that the storage could be experiencing significant issues for a
significant period of time >10 minutes.   Since the storage has to be
fixed to get things working again, there is a lot of negative value
that requires manual recovery steps when an error gets returned (fsck,
loss of data).

We also manually disable queueing if we need to remove the mpath
devices (paths are already gone as they were non-responsive > 24 hours
and removed via tmo_timeout), and/or forcible reboot the nodes when we
determine storage is not coming back.


On Mon, Nov 27, 2023 at 3:54=E2=80=AFPM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> If a multipath device has no_path_retry set to a number and has lost all
> paths, gone into recovery mode, and timed out, it will disable
> queue_if_no_paths. After that, if one of those failed paths is removed,
> when the device is reloaded, queue_if_no_paths will be re-enabled.  When
> set_no_path_retry() is then called to update the queueing state, it will
> not disable queue_if_no_paths, since the device is still in the recovery
> state, so it believes no work needs to be done. The device will remain
> in the recovery state, with retry_ticks at 0, and queueing enabled,
> even though there are no usable paths.
>
> To fix this, in set_no_path_retry(), if no_path_retry is set to a number
> and the device is queueing but it is in recovery mode and out of
> retries with no usable paths, manually disable queue_if_no_path.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/structs_vec.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 0e8a46e7..3cb23c73 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -627,8 +627,18 @@ void set_no_path_retry(struct multipath *mpp)
>                             !mpp->in_recovery)
>                                 dm_queue_if_no_path(mpp->alias, 1);
>                         leave_recovery_mode(mpp);
> -               } else if (pathcount(mpp, PATH_PENDING) =3D=3D 0)
> +               } else if (pathcount(mpp, PATH_PENDING) =3D=3D 0) {
> +                       /*
> +                        * If in_recovery is set, enter_recovery_mode doe=
s
> +                        * nothing. If the device is already in recovery
> +                        * mode and has already timed out, manually call
> +                        * dm_queue_if_no_path to stop it from queueing.
> +                        */
> +                       if ((!mpp->features || is_queueing) &&
> +                           mpp->in_recovery && mpp->retry_tick =3D=3D 0)
> +                               dm_queue_if_no_path(mpp->alias, 0);
>                         enter_recovery_mode(mpp);
> +               }
>                 break;
>         }
>  }
> --
> 2.41.0
>
>
